#!/bin/bash
set -euxo pipefail

UNIQUE_ID=$(agent variable get randomid)

# Remove the VM resource group, as we no longer need it
az group delete --name workshop-demo-rg-$UNIQUE_ID-vm --no-wait --yes
