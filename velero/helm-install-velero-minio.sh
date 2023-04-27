#!/bin/bash
helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts

cat <<EOF > credentials-velero
[default]
aws_access_key_id = minio
aws_secret_access_key = minio123
EOF

helm install velero \
    --namespace=velero \
    --create-namespace \
    --set-file credentials.secretContents.cloud=credentials-velero \
    --set configuration.backupStorageLocation[0].name=default \
    --set configuration.backupStorageLocation[0].provider=aws \
    --set configuration.backupStorageLocation[0].bucket=velero \
    --set configuration.backupStorageLocation[0].config.region=minio-default \
    --set configuration.backupStorageLocation[0].config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation[0].config.s3Url=http://minio-default.velero.svc.cluster.local:9000 \
    --set configuration.backupStorageLocation[0].config.publicUrl=http://localhost:9000 \
    --set configuration.backupStorageLocation[1].name=primary \
    --set configuration.backupStorageLocation[1].provider=aws \
    --set configuration.backupStorageLocation[1].bucket=velero \
    --set configuration.backupStorageLocation[1].config.region=minio-primary \
    --set configuration.backupStorageLocation[1].config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation[1].config.s3Url=http://minio-primary.velero.svc.cluster.local:9000 \
    --set configuration.backupStorageLocation[2].name=secondary \
    --set configuration.backupStorageLocation[2].provider=aws \
    --set configuration.backupStorageLocation[2].bucket=velero \
    --set configuration.backupStorageLocation[2].config.region=minio-secondary \
    --set configuration.backupStorageLocation[2].config.s3ForcePathStyle=true \
    --set configuration.backupStorageLocation[2].config.s3Url=http://minio-secondary.velero.svc.cluster.local:9000 \
    --set snapshotsEnabled=true \
    --set deployNodeAgent=true \
    --set configuration.volumeSnapshotLocation[0].name=default \
    --set configuration.volumeSnapshotLocation[0].provider=aws \
    --set configuration.volumeSnapshotLocation[0].config.region=minio-default \
    --set initContainers[0].name=velero-plugin-for-aws \
    --set initContainers[0].image=velero/velero-plugin-for-aws:v1.7.0 \
    --set initContainers[0].volumeMounts[0].mountPath=/target \
    --set initContainers[0].volumeMounts[0].name=plugins \
    vmware-tanzu/velero
