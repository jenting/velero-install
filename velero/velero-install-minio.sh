#!/bin/bash

velero install \
    --secret-file=./credentials-velero \
    --provider=aws \
    --bucket=velero \
    --backup-location-config region=minio-default,s3ForcePathStyle=true,s3Url=http://minio-default.velero.svc.cluster.local:9000,publicUrl=http://localhost:9000 \
region=minio-default \
    --plugins=velero/velero-plugin-for-aws:v1.2.1 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --snapshot-location-config region=minio-default \
    --wait
