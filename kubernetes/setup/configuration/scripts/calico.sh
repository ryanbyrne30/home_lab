#!/bin/bash

# Reference: https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises

echo
echo "================================="
echo "Installing and Configuring Calico"
echo "================================="

# Install the operator on your cluster
echo
echo "Installing operator"
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/tigera-operator.yaml

# Download the custom resources necessary to configure Calico
echo
echo "Download necessary resources"
curl https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/custom-resources.yaml -O

# Create the manifest in order to install Calico.
echo
echo "Create the manifest"
kubectl create -f custom-resources.yaml

# Verify Calico is running
watch kubectl get pods -n calico-system