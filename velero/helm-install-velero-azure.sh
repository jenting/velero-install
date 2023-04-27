#!/bin/bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.backupStorageLocation[0].name=default \
    --set configuration.backupStorageLocation[0].provider=azure \
    --set configuration.backupStorageLocation[0].bucket=$BUCKET \
    --set configuration.backupStorageLocation[0].config.resourceGroup=$AZURE_RESOURCE_GROUP \
    --set configuration.backupStorageLocation[0].config.storageAccount=$AZURE_STORAGE_ACCOUNT_ID \
    --set snapshotsEnabled=true \
    --set deployNodeAgent=true \
    --set configuration.volumeSnapshotLocation[0].name=default \
    --set configuration.volumeSnapshotLocation[0].provider=azure \
    --set initContainers[0].name=velero-plugin-for-microsoft-azure \
    --set initContainers[0].image=velero/velero-plugin-for-microsoft-azure:v1.5.3 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    vmware-tanzu/velero
