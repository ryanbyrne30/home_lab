#!/bin/bash

SCRIPTS=(
  "kubectl.sh"
  "container_images.sh"
)

for script in "${SCRIPTS[@]}"; do 
  echo "Running script: ./scripts/$script"
  bash ./scripts/$script
done