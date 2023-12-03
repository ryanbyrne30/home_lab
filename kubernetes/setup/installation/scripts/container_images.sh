#!/bin/bash
VERSION="v1.28.4"

IMAGES=(
  "registry.k8s.io/kube-apiserver:$VERSION"
  "registry.k8s.io/kube-controller-manager:$VERSION"
  "registry.k8s.io/kube-proxy:$VERSION"
  "registry.k8s.io/kube-scheduler:$VERSION"
  "registry.k8s.io/kube-conformance:$VERSION"
)

for image in "${IMAGES[@]}"; do
  sudo docker pull $image
done