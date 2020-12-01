#!/bin/bash
helm3 repo add minio https://helm.min.io/

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
    minio/minio

helm3 install minio-primary \
    --namespace velero \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    minio/minio

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
    minio/minio
