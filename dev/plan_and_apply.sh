#!/bin/bash
cd ../; ./sync.sh; cd dev
terraform plan -out=deployment.tfplan; terraform apply deployment.tfplan

