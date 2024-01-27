#!/bin/bash

# Reference: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin

# Disable SWAP memory
echo "Disabling SWAP memory"
sudo swapoff -a                                     # reference: https://unix.stackexchange.com/questions/23072/how-can-i-check-if-swap-is-active-from-the-command-line
sudo sed -e '/\sswap\s/ s/^#*/#/' -i /etc/fstab     # reference: https://askubuntu.com/questions/214805/how-do-i-disable-swap
echo "Confirming SWAP is disabled (should be empty) -> $(swapon -s)"