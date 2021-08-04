#!/bin/bash

velero install \
    --provider=aws \
    --bucket=$BUCKET \
    --secret-file=./credentials-velero \
    --image=velero/velero:v1.2.1 \
    --backup-location-config=region=$REGION \
    --plugins=velero/velero-plugin-for-aws:v1.0.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --snapshot-location-config=region=$REGION \
    --wait
