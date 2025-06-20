#!/bin/bash
set -euxo pipefail

curl -L https://github.com/ArmDeveloperEcosystem/kubearchinspect/releases/download/v0.6.0/kubearchinspect_Linux_x86_64.tar.gz > kubearchinspect.tar.gz

mkdir -p kubearchinspect
tar -xzf kubearchinspect.tar.gz -C kubearchinspect
