#!/bin/bash
helm3 repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm3 install velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=aws \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=$BUCKET \
    --set configuration.backupStorageLocation.config.region=$REGION \
    --set snapshotsEnabled=true \
    --set deployRestic=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set configuration.volumeSnapshotLocation.config.region=$REGION \
    --set initContainers[0].name=velero-plugin-for-aws \
    --set initContainers[0].image=velero/velero-plugin-for-aws:v1.0.1 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    --set cleanUpCRDs=true \
    --wait \
    vmware-tanzu/velero
