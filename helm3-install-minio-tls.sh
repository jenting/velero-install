#!/bin/bash
helm3 repo add stable https://kubernetes-charts.storage.googleapis.com

mkcert minio
mv ./minio-key.pem private.key
mv ./minio.pem public.crt

kubectl delete secret tls-ssl-minio -n velero
kubectl create secret generic tls-ssl-minio --from-file=private.key --from-file=public.crt -n velero

helm3 install minio \
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set tls.enabled=true \
    --set tls.certSecret=tls-ssl-minio \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    stable/minio
