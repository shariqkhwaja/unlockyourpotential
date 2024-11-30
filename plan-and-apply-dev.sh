rm -rf environments/.terraform environments/.terraform.lock.hcl

terraform -chdir=environments init \
  -backend-config="resource_group_name=rg-up-tfstate" \
  -backend-config="storage_account_name=sauptfstate" \
  -backend-config="container_name=tfstate-dev" \
  -backend-config="key=tfstate-dev" \
  -upgrade

terraform -chdir=environments plan \
  -var="azure_subscription_id=5d0a772f-2d86-4fb5-8ecd-d19934a16dd8" \
  -var="application_key=up" \
  -var="environment_key=dev" \
  -var="dns_zone_name=unlockyourpotential.ai" \
  -var="resource_group_location=australiasoutheast" \
  -var="core_resource_group_name=rg-up-core" \
  -var="static_website_location=eastasia" \
  -out=tfplan-dev

terraform -chdir=environments apply tfplan-dev
rm -rf environments/tfplan-dev environments/.terraform environments/.terraform.lock.hcl tfplan-dev
