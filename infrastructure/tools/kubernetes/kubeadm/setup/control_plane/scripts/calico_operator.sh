#!/bin/bash

# Reference: https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises
# Quick start reference: https://docs.tigera.io/calico/latest/getting-started/kubernetes/quickstart#before-you-begin

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

echo "**************"
echo "Before moving on, make sure the custom-resources.yaml file is configured to your spec."
echo "You may need to modify the default IP pool CIDR to match your pod network CIDR"
echo "**************"
echo "Exiting until action above is complete"
exit 0

# Create the manifest in order to install Calico.
echo
echo "Create the manifest"
kubectl create -f custom-resources.yaml

# Verify Calico is running
#watch kubectl get pods -n calico-system 

# Remove the taints on the control plane so that you can schedule pods on it
echo
#echo "Removing taints"
#kubectl taint nodes --all node-role.kubernetes.io/control-plane-
#kubectl taint nodes --all node-role.kubernetes.io/master-
#echo "The above should return -> node/<your-hostname> untainted"

# Confirm you have a node on your cluster
echo
echo "Confirming node"
kubectl get nodes -o wide