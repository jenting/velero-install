#!/bin/bash

velero install \
    --provider=gcp \
    --bucket=$BUCKET \
    --secret-file=./credentials-velero \
    --plugins=velero/velero-plugin-for-gcp:v1.7.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --wait	
