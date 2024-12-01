rm -rf core/tfplan-core core/.terraform core/.terraform.lock.hcl

terraform -chdir=core init \
  -backend-config="resource_group_name=rg-up-tfstate" \
  -backend-config="storage_account_name=sauptfstate" \
  -backend-config="container_name=tfstate-core" \
  -backend-config="key=tfstate-core" \
  -upgrade

terraform -chdir=core plan \
  -var="azure_subscription_id=5d0a772f-2d86-4fb5-8ecd-d19934a16dd8" \
  -var="application_key=up" \
  -var="environment_key=core" \
  -var="dns_zone_name=unlockyourpotential.ai" \
  -var="resource_group_location=australiasoutheast" \
  -out=tfplan-core

terraform -chdir=core apply tfplan-core
rm -rf core/tfplan-core core/.terraform core/.terraform.lock.hcl tfplan-core
