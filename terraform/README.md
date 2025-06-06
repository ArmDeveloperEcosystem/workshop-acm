# Terraform Project Overview

This document provides an overview of the different Terraform files in this folder and their purposes.

## Files

### `providers.tf`

This file contains the configuration for the Terraform project and which provider versions to use.

### `variables.tf`

This file defines the input variables for the Terraform project. It allows you to parameterize the configuration and make it more flexible.

### `main.tf`

This file contains the primary configuration for the Terraform project. It defines the Azure resource group that will be used by Terraform.

### `acr.tf`

This file configures the Azure Container Registry (ACR) resource. It defines the repository where Docker images will be stored and managed.

### `aks.tf`

This file sets up the Azure Kubernetes Service (AKS) resources. It defines the AKS cluster and node groups, enabling the deployment and management of containerized applications on Kubernetes.

### `outputs.tf`

This file specifies the outputs of the Terraform project. Outputs values that are created by Terraform and can then be displayed to the user, or copied to other platforms like GitHub Actions.

## Usage

To use this Terraform configuration, follow these steps:

1. Ensure local environment variables are set for Azure:

    ```sh
    az login
    ```

    You can confirm you are set up for the desired subscription with:

    ```sh
    az account show
    ```

1. Initialize the Terraform project:

    ```sh
    terraform init
    ```

1. Review the execution plan:

    You can pass in the subscription ID for the subscription you'd like to deploy to.

    ```sh
    terraform plan -var="subscription_id=<put your subscription ID here>"
    ```

    If you want to do the current configured subscription, this code will automatically populate the subscription id:

    ```sh
    terraform plan -var="subscription_id=$(az account show --query id --output tsv)"
    ```

1. Apply the configuration:

    Same as above, to this code will automatically populate the subscription id:

    ```sh
    terraform apply -var="subscription_id=$(az account show --query id --output tsv)"
    ```

1. Destroy the infrastructure (when done):

    ```sh
    terraform destroy
    ```
