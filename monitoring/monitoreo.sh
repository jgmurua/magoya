#!/bin/bash

helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

helm upgrade --install prometheus prometheus-community/prometheus --namespace monitoring
helm upgrade --install loki grafana/loki-stack --namespace monitoring
helm upgrade --install grafana grafana/grafana --namespace monitoring -f datasource.yaml

