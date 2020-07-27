#!/bin/bash

velero install \
    --secret-file=./credentials-velero \
    --provider=aws \
    --bucket=velero \
    --backup-location-config region=minio-default,s3ForcePathStyle=true,s3Url=https://minio-default.velero.svc.cluster.local:9000 \
    --plugins=velero/velero-plugin-for-aws:v1.1.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --snapshot-location-config region=minio-default \
    --cacert $HOME/.local/share/mkcert/rootCA.pem \
    --wait

velero install \
    --secret-file=./credentials-velero \
    --provider=aws \
    --bucket=velero \
    --backup-location-config region=minio-secondary,s3ForcePathStyle=true,s3Url=https://minio-secondary.velero.svc.cluster.local:9000 \
    --plugins=velero/velero-plugin-for-aws:v1.1.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --snapshot-location-config region=minio-secondary \
    --cacert $HOME/.local/share/mkcert/rootCA.pem \
    --wait
