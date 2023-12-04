#!/bin/bash

# Reference: https://kubernetes.io/docs/setup/production-environment/container-runtimes/ 

echo
echo "============================================="
echo "Installing and Configuring Container Runtimes"
echo "============================================="

# Prerequisites
echo
echo "Step 1. Prerequisites"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify that the br_netfilter, overlay modules are loaded
echo
echo "Step 2. Verify br_netfilter, overlay modules are loaded"
lsmod | grep br_netfilter
lsmod | grep overlay

# Verify that the net.bridge.bridge-nf-call-iptables, net.bridge.bridge-nf-call-ip6tables, and net.ipv4.ip_forward system variables are set to 1 in your sysctl config 
echo
echo "Step 3. Verify iptables are configured properly"
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward

echo
echo "---------------------"
echo "Installing containerd"
echo "---------------------"

# Reference: https://github.com/containerd/containerd/blob/main/docs/getting-started.md

# Download containerd from: https://github.com/containerd/containerd/releases
CONTAINERD_VERSION="1.7.10"
CONTAINERD="containerd-$CONTAINERD_VERSION-linux-amd64.tar.gz"
CONTAINERD_DOWNLOAD_URL="https://github.com/containerd/containerd/releases/download/v$CONTAINERD_VERSION/$CONTAINERD"
echo
echo "Installing containerd: $CONTAINERD_DOWNLOAD_URL"
curl -L -o $CONTAINERD $CONTAINERD_DOWNLOAD_URL 
sudo tar Cxzvf /usr/local $CONTAINERD
rm $CONTAINERD

# Install containerd systemd service file
echo
echo "Install containerd.service"
CONTAINERD_SERVICE=containerd.service
sudo mkdir -p /usr/local/lib/systemd/system
sudo curl -L -o /usr/local/lib/systemd/system/$CONTAINERD_SERVICE https://raw.githubusercontent.com/containerd/containerd/main/$CONTAINERD_SERVICE
sudo systemctl daemon-reload
sudo systemctl enable --now containerd

echo
echo "---------------------"
echo "Installing runc"
echo "---------------------"

# Download and install runc
echo
echo "Install runc"
RUNC_VERSION="v1.1.10"
RUNC="runc.amd64"
curl -L -o $RUNC https://github.com/opencontainers/runc/releases/download/$RUNC_VERSION/$RUNC
sudo install -m 755 $RUNC /usr/local/sbin/runc
rm $RUNC

echo
echo "---------------------"
echo "Installing CNI plugins"
echo "---------------------"

# Installing CNI plugins
echo
echo "Installing CNI plugins"
CNI_VERSION="v1.3.0"
CNI="cni-plugins-linux-amd64-$CNI_VERSION.tgz"
curl -L -o $CNI https://github.com/containernetworking/plugins/releases/download/$CNI_VERSION/$CNI
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin $CNI
rm $CNI

# Create config.toml
# Reference: https://github.com/containerd/containerd/blob/main/docs/getting-started.md#customizing-containerd
echo
echo "Creating config.toml for containerd"
sudo mkdir -p /etc/containerd
sudo sh -c 'containerd config default > /etc/containerd/config.toml'

# Verify installation
echo
echo "Verifying installation"
ls -la /etc/containerd/config.toml

# Configure containerd for kubernetes
# Reference: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd
echo
echo "Configuring containerd for K8s"
sudo sed -i -e '/SystemdCgroup/ s/false/true/' /etc/containerd/config.toml

# Override the sandbox (pause) image
# Reference: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#override-pause-image-containerd
# Already configured by default -> Skipping

# Restart containerd
echo
echo "Restarting containerd
sudo systemctl restart containerd

echo "Containerd is now installed and configured"

