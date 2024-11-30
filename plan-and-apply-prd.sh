rm -rf environments/.terraform environments/.terraform.lock.hcl

terraform -chdir=environments init \
  -backend-config="resource_group_name=rg-up-tfstate" \
  -backend-config="storage_account_name=sauptfstate" \
  -backend-config="container_name=tfstate-prd" \
  -backend-config="key=tfstate-prd" \
  -upgrade

terraform -chdir=environments plan \
  -var="azure_subscription_id=5d0a772f-2d86-4fb5-8ecd-d19934a16dd8" \
  -var="application_key=up" \
  -var="environment_key=prd" \
  -var="dns_zone_name=unlockyourpotential.ai" \
  -var="resource_group_location=australiasoutheast" \
  -var="core_resource_group_name=rg-up-core" \
  -var="static_website_location=eastasia" \
  -out=tfplan-prd

terraform -chdir=environments apply tfplan-prd
rm -rf environments/tfplan-prd environments/.terraform environments/.terraform.lock.hcl
