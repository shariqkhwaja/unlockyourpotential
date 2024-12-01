#!/bin/bash

# Check for environment argument
if [ -z "$1" ]; then
  echo "Usage: $0 <environment_key>"
  echo "Valid environment keys: dev, stg, prd"
  exit 1
fi

ENVIRONMENT_KEY=$1

# Clean up previous Terraform state files
rm -rf environments/.terraform environments/.terraform.lock.hcl

# Initialize Terraform with backend configuration
terraform -chdir=environments init \
  -backend-config="resource_group_name=rg-up-tfstate" \
  -backend-config="storage_account_name=sauptfstate" \
  -backend-config="container_name=tfstate-${ENVIRONMENT_KEY}" \
  -backend-config="key=tfstate-${ENVIRONMENT_KEY}" \
  -upgrade

# Plan Terraform using the common.tfvars file and environment_key from the command line
terraform -chdir=environments plan \
  -var-file="../common.tfvars" \
  -var="environment_key=${ENVIRONMENT_KEY}" \
  -out=tfplan-${ENVIRONMENT_KEY}

# Apply the Terraform plan
terraform -chdir=environments apply tfplan-${ENVIRONMENT_KEY}

# Clean up temporary files
rm -rf environments/tfplan-${ENVIRONMENT_KEY} environments/.terraform environments/.terraform.lock.hcl tfplan-${ENVIRONMENT_KEY}
