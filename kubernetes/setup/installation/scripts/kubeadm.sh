#!/bin/bash

# Reference: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm

# Disable SWAP memory
echo "Disabling SWAP memory"
sudo swapoff -a
sudo sed -e '/\sswap\s/ s/^#*/#/' -i /etc/fstab
echo "Confirming SWAP is disabled (should be empty) -> $(swapon -s)"