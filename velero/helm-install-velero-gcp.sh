#!/bin/bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.backupStorageLocation[0].name=default \
    --set configuration.backupStorageLocation[0].provider=gcp \
    --set configuration.backupStorageLocation[0].bucket=$BUCKET \
    --set snapshotsEnabled=true \
    --set deployNodeAgent=true \
    --set configuration.volumeSnapshotLocation[0].name=default \
    --set configuration.volumeSnapshotLocation[0].provider=gcp \
    --set initContainers[0].name=velero-plugin-for-gcp \
    --set initContainers[0].image=velero/velero-plugin-for-gcp:v1.7.0 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    vmware-tanzu/velero
