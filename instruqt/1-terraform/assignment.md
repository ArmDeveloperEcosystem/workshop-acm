# Azure Cloud Migration workshop

This workshop demonstrates how to create and run a quantized LLM inference pipeline using PyTorch, then deploy the backend to the cloud using a multi-architectural Azure Kubernetes service with both AMD and Arm based nodes. You will then connect a chatbot application using Streamlit and Torchchat to the AKS load balancer, allowing for a user-friendly browser-based interface powered by PyTorch and running on a scalable Kubernetes based backend.

Through instruqt you have been given:

- An Azure subscription
- A terminal to work in with the required tools (git, azure cli, terraform) already installed

> [!NOTE]
> Your Azure CLI should already be configured by Instruqt and authorized to the correct Azure subscription.
> You can confirm this by running `az account show`

## Deploy resources via Terraform

In your [Terminal tab](tab-0), write the following command to prepare the current working directory for use with Terraform:

[button label="Terminal"](tab-0)

```bash,run
terraform init
```

### Terraform Plan

Then you can run `terraform plan` to see what we will deploy:

```bash,run
terraform plan -var="subscription_id=$(az account show --query id --output tsv)" -var="random_id=[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]" -out tfplan
```

We pass in two variables to the terraform. First is the current Azure subscription, and the second is a random string of characters (in your case, `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]`) which will be used to make unique resource names within Azure.

You should get output that says there are no errors and shows you everything that will be deployed when you apply.

### Terraform Apply

After successfully running `terraform plan`, let's apply our plan to deploy via terraform:

```bash,run
terraform apply tfplan
```

> [!WARNING]
> Wait until deployment is complete and successful before moving on to the next challenge!

This will take a few minutes to run. Instruqt may give you a prompt you "Are you still there?" due to inaction, make sure you watch the screen and interact as needed to ensure deployment finishes.

> [!IMPORTANT]
> When the deployment is done, take a note of the "output" values.
> This workshop assumes you used the instruqt generated value the random_id `[[ Instruqt-Var key="randomid" hostname="cloud-client" ]]`.
> If you do not define the random_id variable, terraform will generate a unique string. However, you'll need to manually save the output values for later steps.

### What are we deploying?
===

Switch to the [Editor](tab-1) tab to take a look at our terraform files while your deployment is running:

[button label="Editor"](tab-1)

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

### `ssh.tf`

This file sets up a SSH key for the Azure VM.

### `vm.tf`

This file configured an Azure VM that we can access via public network using a SSH key.

### `outputs.tf`

This file specifies the outputs of the Terraform project. Outputs values that are created by Terraform and can then be displayed to the user, or copied to other platforms like GitHub Actions.

When the terraform finishes deploying, click the **Next** button below.
