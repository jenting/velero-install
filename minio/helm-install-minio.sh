#!/bin/bash
bitnami https://charts.bitnami.com/bitnami

helm install minio-default \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    bitnami/minio

helm install minio-primary \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    bitnami/minio

helm install minio-secondary \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    bitnami/minio
