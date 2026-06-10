#!/bin/bash

set -e

echo "Installing K3s..."

curl -sfL https://get.k3s.io | sh -

sleep 20

sudo chmod 644 /etc/rancher/k3s/k3s.yaml

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "Installing AWX Operator..."

kubectl create namespace awx || true

kubectl apply -f https://raw.githubusercontent.com/ansible/awx-operator/devel/config/default/kustomization.yaml

sleep 60

cat <<EOF >/tmp/awx.yaml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
  namespace: awx
spec:
  service_type: NodePort
  nodeport_port: 30080
EOF

kubectl apply -f /tmp/awx.yaml

echo "Waiting for AWX..."

sleep 180

kubectl get pods -n awx

kubectl get svc -n awx