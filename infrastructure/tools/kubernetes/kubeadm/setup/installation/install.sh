#!/bin/bash

SCRIPTS=(
  "container_runtimes"
  "disable_swap.sh"
  "k8s_tools.sh"
)

for script in "${SCRIPTS[@]}"; do 
  echo "Running script: ./scripts/$script"
  bash ./scripts/$script
done