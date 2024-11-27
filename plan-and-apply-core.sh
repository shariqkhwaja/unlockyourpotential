#!/bin/bash

terraform -chdir=core plan -out=tfplan-core
terraform -chdir=core apply -auto-approve tfplan-core
rm tfplan-core