#!/usr/bin/env bash
set -euxo pipefail

###############################################################################
# Azure ARM-based VM Launch Script (using standard service principal credentials)
#
# This script logs in non-interactively using service principal credentials.
# It assumes that the following environment variables are set:
#   ARM_CLIENT_ID
#   ARM_CLIENT_SECRET
#   ARM_TENANT_ID
#
# Deployment variables are defined at the top for ease of editing.
###############################################################################

# Deployment variables
location="${AZURE_LOCATION:-eastus}"

# Project variable
agent variable set randomid $(head /dev/urandom | tr -dc 'a-z' | head -c 5)

###############################################################################
# Install terraform
###############################################################################
wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt install terraform

###############################################################################
# Login using service principal credentials.
###############################################################################
until az login --service-principal --username "$ARM_CLIENT_ID" --password "$ARM_CLIENT_SECRET" --tenant "$ARM_TENANT_ID" --output none; do
  echo "Service principal login failed. Retrying in 3 seconds..."
  sleep 3
done
echo "Logged in using service principal. Using Azure location: $location"

###############################################################################
# Clone Git repo
###############################################################################
git clone https://github.com/ArmDeveloperEcosystem/workshop-acm.git acm

# TODO: Remove these extra steps
cd acm
git checkout development