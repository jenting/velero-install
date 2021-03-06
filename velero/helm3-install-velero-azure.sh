#!/bin/bash
helm3 repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm3 install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=azure \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=$BUCKET \
    --set configuration.backupStorageLocation.config.resourceGroup=$AZURE_RESOURCE_GROUP \
    --set configuration.backupStorageLocation.config.storageAccount=$AZURE_STORAGE_ACCOUNT_ID \
    --set snapshotsEnabled=true \
    --set deployRestic=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set initContainers[0].name=velero-plugin-for-microsoft-azure \
    --set initContainers[0].image=velero/velero-plugin-for-microsoft-azure:v1.2.0 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    vmware-tanzu/velero
