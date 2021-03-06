#!/bin/bash

AZURE_RESOURCE_GROUP=Velero_Backups
AZURE_STORAGE_ACCOUNT_ID="velero$(uuidgen | cut -d '-' -f5 | tr '[A-Z]' '[a-z]')"

velero install \
    --provider=azure \
    --bucket=$BUCKET \
    --secret-file=./credentials-velero \
    --image=velero/velero:v1.2.0 \
    --backup-location-config=resourceGroup=$AZURE_RESOURCE_GROUP,storageAccount=$AZURE_STORAGE_ACCOUNT_ID \
    --plugins=velero/velero-plugin-for-microsoft-azure:v1.0.0 \
    --use-volume-snapshots=true \
    --use-restic=true \
    --wait
