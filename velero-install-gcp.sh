#!/bin/bash

velero install \
    --provider=gcp \
    --bucket=$BUCKET \
    --secret-file=./credentials-velero \
    --image=velero/velero:v1.2.0 \
    --plugins=velero/velero-plugin-for-gcp:v1.0.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --wait	
