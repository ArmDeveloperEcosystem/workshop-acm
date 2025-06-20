#!/bin/bash
set -euxo pipefail

UNIQUE_ID=$(agent variable get randomid)

# Stop the VM
az vm stop --name workshop-vm --resource-group workshop-demo-rg-$UNIQUE_ID-vm
