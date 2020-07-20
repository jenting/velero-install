#!/bin/bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

helm install \
    --name velero \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=gcp \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=$BUCKET \
    --set snapshotsEnabled=true \
    --set deployRestic=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set initContainers[0].name=velero-plugin-for-gcp \
    --set initContainers[0].image=velero/velero-plugin-for-gcp:v1.0.1 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    --set cleanUpCRDs=true \
    --wait \
    vmware-tanzu/velero
