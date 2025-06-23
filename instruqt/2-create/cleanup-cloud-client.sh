#!/bin/bash
set -euxo pipefail

UNIQUE_ID=$(agent variable get randomid)

# Stop the VM
az vm deallocate --name workshop-vm --resource-group workshop-demo-rg-$UNIQUE_ID-vm
