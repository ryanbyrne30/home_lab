#!/bin/bash

SCRIPTS=(
  "disable_swap.sh"
  "kubeadm.sh"
  "kubectl.sh"
  "container_images.sh"
)

for script in "${SCRIPTS[@]}"; do 
  echo "Running script: ./scripts/$script"
  bash ./scripts/$script
done