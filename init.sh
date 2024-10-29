#!/bin/bash

terraform -chdir=core init \
-backend-config="resource_group_name=rg-up-tfstate" \
-backend-config="storage_account_name=sauptfstate" \
-backend-config="container_name=tfstate-core" \
-backend-config="key=tfstate-core" \
-upgrade


terraform -chdir=dev init \
-backend-config="resource_group_name=rg-up-tfstate" \
-backend-config="storage_account_name=sauptfstate" \
-backend-config="container_name=tfstate-dev" \
-backend-config="key=tfstate-dev" \
-upgrade