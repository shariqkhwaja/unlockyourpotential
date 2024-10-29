#!/bin/bash

az rest --method delete --header "Accept=application/json" -u 'https://management.azure.com/subscriptions/cdd486de-fbdc-4de4-84f0-2ddd44579a48/resourceGroups/rg-up-dev/providers/Microsoft.ApiManagement/service/am-up-dev?api-version=2020-06-01-preview'
