#!/bin/bash

velero install \
    --provider=aws \
    --bucket=$BUCKET \
    --secret-file=./credentials-velero \
    --backup-location-config=region=$REGION \
    --plugins=velero/velero-plugin-for-aws:v1.5.3 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --snapshot-location-config=region=$REGION \
    --wait
