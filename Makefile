set-command-alias-powershell:
	 Set-Alias tf terraform

set-command-alias-bash:
	 alias tf='terraform'

create-env-variable-powershell:
	 $env:TF_VAR_project_name="Project ALPHA Resource"

create-plan:
	terraform plan

apply-changes:
	terraform apply --auto-approve

initialize-terraform:
	terraform init

destroy-terraform-resources:
	terraform destroy

refresh-terraform-config:
	terraform refresh

cli-to-get-role-assignment-id-key-vault:
	az role assignment list --assignee 22aec37b-c5b8-4344-b353-d7252288b6cb --scope "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.KeyVault/vaults/app-secrets-kv-22" --query "[].id" -o tsv

cli-to-get-role-assignment-id-storage-account:
	az role assignment list `
	>>   --assignee 22aec37b-c5b8-4344-b353-d7252288b6cb `
	>>   --scope "/subscriptions/fa1a5f03-4a4f-4eb3-bef5-69e3b3b094da/resourceGroups/app-resource-rg/providers/Microsoft.Storage/storageAccounts/appstorage123" `
	>>   --query "[].id" -o tsv

