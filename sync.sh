#!/bin/bash

mkdir -p stg
mkdir -p prd

cd dev

for files in *.tf
do
  cat $files | sed 's/dev/stg/g' > ../stg/$files
  cat $files | sed 's/"dev\./"www\./g; s/dev/prd/g; s/\/\/prd./\/\//' > ../prd/$files
done

cd ../prd

cat main.tf | sed 's/  name                = "prd"/  name                = "www"/' > tmp; mv tmp main.tf
cat main.tf | sed 's/name                = "api-${var.environment_key}"/name                = "api"/' > tmp; mv tmp main.tf
cat main.tf | sed 's/  domain_name     = "${var.environment_key}.${var.dns_zone}"/  domain_name     = "www.${var.dns_zone}"/' > tmp; mv tmp main.tf

cd ../

cat core/plan_and_apply.sh | sed 's/core/dev/' > dev/plan_and_apply.sh
cat core/plan_and_apply.sh | sed 's/core/stg/' > stg/plan_and_apply.sh
cat core/plan_and_apply.sh | sed 's/core/prd/' > prd/plan_and_apply.sh
