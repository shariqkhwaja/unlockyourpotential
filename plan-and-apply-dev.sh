#!/bin/bash

terraform -chdir=dev plan -out=tfplan-dev
terraform -chdir=dev apply -auto-approve tfplan-dev
rm tfplan-dev