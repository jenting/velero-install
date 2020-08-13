#!/bin/bash
helm3 repo add stable https://kubernetes-charts.storage.googleapis.com

helm3 install minio-default \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    stable/minio

helm3 install minio-secondary \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    stable/minio
