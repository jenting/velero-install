#!/bin/bash
helm3 repo add minio https://helm.min.io/

rm minio-default.velero.svc.cluster.local+2.pem
rm minio-default.velero.svc.cluster.local+2-key.pem

mkcert minio-default.velero.svc.cluster.local minio-default localhost
kubectl delete secret minio-default-tls
kubectl create secret generic minio-default-tls -n velero --from-file=public.crt=./minio-default.velero.svc.cluster.local+2.pem --from-file=private.key=./minio-default.velero.svc.cluster.local+2-key.pem

helm3 install minio-default \
    --namespace=velero \		
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set tls.enabled=true \
    --set tls.certSecret=minio-default-tls \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    minio/minio

rm minio-secondary.velero.svc.cluster.local+2.pem
rm minio-secondary.velero.svc.cluster.local+2-key.pem

mkcert minio-secondary.velero.svc.cluster.local minio-secondary localhost
kubectl delete secret minio-secondary-tls
kubectl create secret generic minio-secondary-tls -n velero --from-file=public.crt=./minio-secondary.velero.svc.cluster.local+2.pem --from-file=private.key=./minio-secondary.velero.svc.cluster.local+2-key.pem

helm3 install minio-secondary \
    --namespace=velero \		
    --create-namespace \
    --set resources.requests.memory=1Gi \
    --set persistence.enabled=false \
    --set accessKey=minio \
    --set secretKey=minio123 \
    --set tls.enabled=true \
    --set tls.certSecret=minio-secondary-tls \
    --set buckets[0].name=velero \
    --set buckets[0].policy=public \
    --set buckets[0].purge=true \
    minio/minio
