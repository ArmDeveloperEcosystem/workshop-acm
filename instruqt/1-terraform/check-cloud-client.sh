#!/bin/bash
set -euxo pipefail

# Check if terraform apply is running
if pgrep -f "terraform apply" > /dev/null; then
    echo "Terraform apply is currently running."
    fail-message "Please wait for terraform apply to finish running."
else
    echo "No terraform apply process found."
fi

UNIQUE_ID=$(agent variable get randomid)

# Define the expected resources from Terraform
EXPECTED_RESOURCES=(
    "resourceGroup:workshop-demo-rg-$UNIQUE_ID-aks"
    "resourceGroup:workshop-demo-rg-$UNIQUE_ID-vm"
    "aksCluster:workshop-aks-demo-cluster"
    "acr:workshopacr$UNIQUE_ID"
    "nodePool:armpool"
    "nodePool:amdpool"
    "vm:workshop-vm"
)

# Azure subscription ID
SUBSCRIPTION_ID=$(az account show --query id -o tsv)

# Function to check if a resource exists
check_resource() {
    local resource_type=$1
    local resource_name=$2

    case $resource_type in
        resourceGroup)
            az group show --name "$resource_name" --subscription "$SUBSCRIPTION_ID" &>/dev/null
            ;;
        aksCluster)
            az aks show --name "$resource_name" --resource-group "${EXPECTED_RESOURCES[0]#*:}" --subscription "$SUBSCRIPTION_ID" &>/dev/null
            ;;
        acr)
            az acr show --name "$resource_name" --subscription "$SUBSCRIPTION_ID" &>/dev/null
            ;;
        nodePool)
            az aks nodepool show --cluster-name "${EXPECTED_RESOURCES[2]#*:}" --resource-group "${EXPECTED_RESOURCES[0]#*:}" --name "$resource_name" --subscription "$SUBSCRIPTION_ID" &>/dev/null
            ;;
        vm)
            az vm show --name "$resource_name" --resource-group "${EXPECTED_RESOURCES[1]#*:}" --subscription "$SUBSCRIPTION_ID" &>/dev/null
            ;;
        *)
            echo "Unknown resource type: $resource_type"
            return 1
            ;;
    esac
}

# Check each expected resource
for resource in "${EXPECTED_RESOURCES[@]}"; do
    IFS=":" read -r resource_type resource_name <<<"$resource"
    echo "Checking $resource_type: $resource_name..."
    if check_resource "$resource_type" "$resource_name"; then
        echo "✅ $resource_type '$resource_name' exists."
    else
        echo "❌ $resource_type '$resource_name' is missing."
        fail-message "Not all required resources were found in the Azure subscription: $resource_type '$resource_name' is missing."
    fi
done
