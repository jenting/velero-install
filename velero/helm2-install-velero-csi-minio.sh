#!/bin/bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

cat <<EOF > credentials-velero
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
EOF

helm install \
    --name=velero \
    --namespace=velero \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=aws \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=velero \
    --set configuration.backupStorageLocation.config.region=minio-default \
    --set configuration.backupStorageLocation.config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation.config.s3Url=http://minio-default.velero.svc.cluster.local:9000 \
    --set snapshotsEnabled=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set configuration.volumeSnapshotLocation.config.region=minio-default \
    --set initContainers[0].name=velero-plugin-for-aws \
    --set initContainers[0].image=velero/velero-plugin-for-aws:v1.2.0 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    --set configuration.features=EnableCSI \
    --set initContainers[1].name=velero-plugin-for-csi \
    --set initContainers[1].image=velero/velero-plugin-for-csi:v0.1.2 \
    --set initContainers[1].volumeMounts[0].mountPath=/target \
    --set initContainers[1].volumeMounts[0].name=plugins \
    vmware-tanzu/velero

velero backup-location create secondary \
    --provider aws \
    --bucket velero \
    --config region=minio-secondary,s3ForcePathStyle=true,s3Url=http://minio-secondary.velero.svc.cluster.local:9000
