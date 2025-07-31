# Resource Group import
resource "azurerm_resource_group" "rg" {
    name     = "app-resource-rg"
    location = "East US"
}

import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg"
}

# User Managed Identity
resource "azurerm_user_assigned_identity" "kv_identity" {
  name                = "key-vault-contributor-mi"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  location            = azurerm_resource_group.rg.location
  name                = "app-secrets-kv-22"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "standard"
  tenant_id           = "abf11943-aebc-4f63-affa-0551e6a522ec"
  enable_rbac_authorization = true
}



# # Role Assignment: give UMI Contributor access to the Key Vault
resource "azurerm_role_assignment" "kv_contributor" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Contributor" # match exact existing role
  principal_id         = azurerm_user_assigned_identity.kv_identity.principal_id
}


# # Import UMI
import {
  to = azurerm_user_assigned_identity.kv_identity
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/key-vault-contributor-mi"
}

# Import Key Vault
import {
  to = azurerm_key_vault.kv
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.KeyVault/vaults/app-secrets-kv-22"
}

# # Import Role Assignment (need the real ID)
import {
  to = azurerm_role_assignment.kv_contributor
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.KeyVault/vaults/app-secrets-kv-22/providers/Microsoft.Authorization/roleAssignments/405c2afe-1308-4847-8ca7-c95cec07291f"
}

# Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "applicationsa22"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "canadacentral"
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  allow_nested_items_to_be_public = false
}


# Role Assignment for Storage Account (Avere Contributor)
resource "azurerm_role_assignment" "sa_avere_contributor" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Avere Contributor"
  principal_id         = azurerm_user_assigned_identity.kv_identity.principal_id
}

# Import Storage Account
import {
  to = azurerm_storage_account.storage
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.Storage/storageAccounts/applicationsa22"
}

# Import Storage Account Role Assignment
import {
  to = azurerm_role_assignment.sa_avere_contributor
  id = "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.Storage/storageAccounts/applicationsa22/providers/Microsoft.Authorization/roleAssignments/42e7216d-b4ff-4b38-b467-4254013fc8ca"
}