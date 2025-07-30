Sure! Let’s go **step by step** through **how to authenticate using**:

1. **Service Principals**
2. **Federated Identity (OIDC)**
3. **Managed Identity**
4. **Workload Identity (AKS)**

I’ll show **practical examples** for each.

---

## **1. Service Principal Authentication**

### **Scenario: Terraform or Python script needs to access Azure**

A **Service Principal** uses **Client ID + Client Secret (or Certificate)** to authenticate.

**Steps:**

1. Create a Service Principal:

```bash
az ad sp create-for-rbac --name my-sp --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

**Output:**

```json
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",   # Client ID
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",   # Client Secret
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

2. Authenticate with Service Principal (Azure CLI):

```bash
az login --service-principal \
  --username <appId> \
  --password <password> \
  --tenant <tenant>
```

3. **Use in Terraform or SDKs** with these environment variables:

```bash
export ARM_CLIENT_ID=<appId>
export ARM_CLIENT_SECRET=<password>
export ARM_TENANT_ID=<tenant>
export ARM_SUBSCRIPTION_ID=<subscription>
```

✅ **Used in:** Terraform, Azure DevOps classic pipelines, automation scripts.

---

## **2. Federated Identity (OIDC Authentication)**

### **Scenario: GitHub Actions deploys to Azure without storing secrets**

* Instead of using SP secrets, GitHub **OIDC token** is trusted by Azure.

**Steps:**

1. In **Azure AD** → App registration → Add **Federated Credentials**

    * Select **GitHub Actions** as the provider.
    * Link to your repo and branch.

2. In **GitHub Workflow (`.github/workflows/deploy.yml`)**:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Azure Login using Federated Identity
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          allow-no-subscriptions: true
```

* GitHub automatically **exchanges its OIDC token** with Azure → no secrets stored.

✅ **Used in:** GitHub Actions, cross-cloud federation, secretless CI/CD.

---

## **3. Managed Identity Authentication**

### **Scenario: Azure Function accesses Key Vault without secrets**

1. Enable **Managed Identity**:

    * Azure Function → **Identity** → System-assigned → On
2. Assign Key Vault Access Policy:

   ```bash
   az keyvault set-policy --name myKeyVault --object-id <FunctionMIObjectID> --secret-permissions get list
   ```
3. Authenticate in code without credentials (example: Python):

```python
from azure.identity import ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient

credential = ManagedIdentityCredential()
client = SecretClient(vault_url="https://myKeyVault.vault.azure.net", credential=credential)
secret = client.get_secret("my-secret")
print(secret.value)
```

✅ **No keys or secrets stored; Azure handles rotation automatically.**

---

## **4. Workload Identity (AKS OIDC)**

### **Scenario: AKS Pod accesses Key Vault using OIDC federation**

* This is the **Kubernetes version of federated identity**, replacing old **AAD Pod Identity**.

**Steps:**

1. Enable **Workload Identity** on AKS cluster:

```bash
az aks update -n myAksCluster -g myRG --enable-oidc-issuer --enable-workload-identity
```

2. Create an **App Registration** and **Federated Credential**:

```bash
az ad app create --display-name aks-workload
az ad sp create --id <APP_ID>
az ad app federated-credential create --id <APP_ID> \
  --name aks-pod \
  --issuer <AKS_OIDC_ISSUER> \
  --subject system:serviceaccount:<namespace>:<serviceaccount>
```

3. In your **Pod spec**:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aks-wi-sa
  annotations:
    azure.workload.identity/client-id: <APP_ID>
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  template:
    spec:
      serviceAccountName: aks-wi-sa
```

4. In Pod code (Python):

```python
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

credential = DefaultAzureCredential()
client = SecretClient(vault_url="https://myKeyVault.vault.azure.net", credential=credential)
secret = client.get_secret("my-secret")
print(secret.value)
```

✅ **No secrets in the cluster; pod authenticates via OIDC.**

---

### 🔹 Key Difference in Authentication

| Identity Type      | Auth Mechanism                  | Secrets Stored? |
| ------------------ | ------------------------------- | --------------- |
| Service Principal  | Client ID + Secret / Cert       | ✅ Yes           |
| Federated Identity | OIDC Token from external source | ❌ No            |
| Managed Identity   | Token issued by Azure AD        | ❌ No            |
| Workload Identity  | OIDC Token from AKS Pod         | ❌ No            |

---

If you want, I can **draw a single architecture diagram** showing how all four methods work with Azure Key Vault and Azure Resources for visual clarity.

Do you want me to create that?
Sure! A **User-Assigned Managed Identity (UMI)** is a **managed identity created as a standalone Azure resource**, which you can **assign to one or more Azure resources** (VM, Function App, App Service, AKS, Logic App, etc.) for **secretless authentication**.

Here’s a **complete step-by-step example** on **how to create and use a User-Assigned Managed Identity**.

---

## **1. Create a User-Assigned Managed Identity**

### **Option 1: Azure Portal**

1. Go to **Azure Portal → Search: Managed Identities → Create**
2. Select:

    * **Resource group**
    * **Region**
    * **Name** → e.g., `myUserMI`
3. Click **Review + Create** → **Create**

---

### **Option 2: Azure CLI**

```bash
# Create resource group (if needed)
az group create --name myRG --location eastus

# Create a User-Assigned Managed Identity
az identity create --name myUserMI --resource-group myRG
```

**Output:**

```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "principalId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "id": "/subscriptions/<subID>/resourceGroups/myRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUserMI"
}
```

* **clientId** → Used for authentication in SDKs
* **principalId** → Used to assign RBAC roles

---

## **2. Assign the UMI to a Resource**

### Example: Assign to a **Virtual Machine**

```bash
az vm identity assign --resource-group myRG --name myVM --identities myUserMI
```

OR for an **Azure Function/App Service**:

* Go to **Resource → Identity → User Assigned → + Add** → Select your UMI.

---

## **3. Assign Role to the Managed Identity**

If the resource needs to access, for example, **Azure Key Vault** or **Storage Account**, assign a role:

```bash
# Assign Key Vault Secrets User role
az role assignment create \
    --assignee <principalId-of-UMI> \
    --role "Key Vault Secrets User" \
    --scope /subscriptions/<subID>/resourceGroups/myRG/providers/Microsoft.KeyVault/vaults/myKeyVault
```

---

## **4. Use the User-Assigned Managed Identity in Code**

When using **Azure SDKs**, you can explicitly specify the **Client ID** of the UMI.

**Python Example:**

```python
from azure.identity import ManagedIdentityCredential
from azure.keyvault.secrets import SecretClient

# Use the Client ID of the UMI
credential = ManagedIdentityCredential(client_id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")
client = SecretClient(vault_url="https://myKeyVault.vault.azure.net/", credential=credential)

secret = client.get_secret("my-secret")
print(secret.value)
```

**PowerShell Example:**

```powershell
Connect-AzAccount -Identity -AccountId <clientId-of-UMI>
Get-AzKeyVaultSecret -VaultName myKeyVault -Name "my-secret"
```

---

### ✅ **Key Points**

* **User-assigned identities are reusable** across multiple resources.
* **System-assigned identities** are deleted with the resource, but **user-assigned** are persistent.
* Use **RBAC roles or Key Vault Access Policies** to grant permissions.
* **SDKs and Azure CLI automatically get tokens** from the UMI without storing secrets.

---

If you want, I can also **compare System-Assigned vs User-Assigned Managed Identity with pros and cons** for clarity.

Do you want me to create that comparison table?
