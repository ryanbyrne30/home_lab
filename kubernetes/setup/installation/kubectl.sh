#!/bin/bash

# Installation steps found here: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

# Download latest release of kubectl
# To download a specific version, replace the $(curl -L -s https://dl.k8s.io/release/stable.txt) portion of the command with the specific version.
# For example, to download version 1.28.4 on Linux x86-64, type:
# curl -LO https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl
echo "Downloading the kubectl binary
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download the kubectl checksum
echo "Downloading the kubectl checksum"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Validate the kubectl binary against the checksum file
echo "Validating checksum"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl
echo "Installing kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Test kubectl
echo "kubectl version..."
kubectl version --client