#!/bin/bash
set -euxo pipefail

# Variables
UNIQUE_ID=$(agent variable get randomid)
ACR_NAME="armacr$UNIQUE_ID"

for IMAGE_NAME in "acmworkshopllm" "acmworkshopclient"; do
    # Check if the image exists in the ACR
    if az acr repository show --name "$ACR_NAME" --repository "$IMAGE_NAME" &> /dev/null; then
        echo "Image '$IMAGE_NAME' exists in ACR '$ACR_NAME'."
    else
        echo "Image '$IMAGE_NAME' does not exist in ACR '$ACR_NAME'."
        fail-message "Image '$IMAGE_NAME' was not successfully imported to ACR '$ACR_NAME'."
    fi
done
