#!/bin/bash
helm3 repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

cat <<EOF > credentials-velero
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
EOF

helm3 install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.provider=aws \
    --set configuration.backupStorageLocation.name=default \
    --set configuration.backupStorageLocation.bucket=velero \
    --set configuration.backupStorageLocation.config.region=minio-default \
    --set configuration.backupStorageLocation.config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation.config.s3Url=http://minio-default.velero.svc.cluster.local:9000 \
    --set configuration.backupStorageLocation.config.publicUrl=http://localhost:9000 \
    --set snapshotsEnabled=true \
    --set deployRestic=true \
    --set configuration.volumeSnapshotLocation.name=default \
    --set configuration.volumeSnapshotLocation.config.region=minio-default \
    --set initContainers[0].name=velero-plugin-for-aws \
    --set initContainers[0].image=velero/velero-plugin-for-aws:v1.2.0 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    vmware-tanzu/velero

velero backup-location create default \
    --provider aws \
    --bucket velero \
    --config region=minio-default,s3ForcePathStyle=true,s3Url=http://minio-default.velero.svc.cluster.local:9000

velero backup-location create primary \
    --provider aws \
    --bucket velero \
    --config region=minio-primary,s3ForcePathStyle=true,s3Url=http://minio-primary.velero.svc.cluster.local:9000

velero backup-location create secondary \
    --provider aws \
    --bucket velero \
    --config region=minio-secondary,s3ForcePathStyle=true,s3Url=http://minio-secondary.velero.svc.cluster.local:9000
