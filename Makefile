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