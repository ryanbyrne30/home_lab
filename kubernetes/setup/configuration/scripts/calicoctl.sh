#!/bin/bash

# Reference: https://docs.tigera.io/calico/latest/operations/calicoctl/install

echo
echo "===================="
echo "Installing calicoctl"
echo "===================="

# Download and install calicoctl binary
echo
echo "Downloading binary"
curl -L https://github.com/projectcalico/calico/releases/download/v3.26.4/calicoctl-linux-amd64 -o calicoctl
chmod +x calicoctl
sudo mv calicoctl /usr/local/bin