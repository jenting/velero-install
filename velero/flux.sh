cat <<EOF | kubectl apply -f -
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: velero
  namespace: velero
  annotations:
    fluxcd.io/automated: "false"
spec:
  releaseName: velero
  chart:
    repository: https://vmware-tanzu.github.io/helm-charts
    name: velero
    version: 2.13.6
  values:
    image:
      repository: velero/velero
      tag: v1.5.2
    configuration:
      backupStorageLocation:
        bucket: velero
        name: default
        config:
          region: minio-default
          s3ForcePathStyle: true
          s3Url: http://minio-default.velero.svc.cluster.local:9000
          publicUrl: http://localhost:9000
        accessMode: ReadWrite
      provider: aws
      resticTimout: 4h
      volumeSnapshotLocation:
        name: default
    credentials:
      existingSecret: cloud-credentials
      useSecret: true
    deployRestic: false
    initContainers:
    - image: velero/velero-plugin-for-aws:v1.2.0
      imagePullPolicy: IfNotPresent
      name: velero-plugin-for-aws
      volumeMounts:
      - mountPath: /target
        name: plugins
    enablehelmhooks: false
    metrics:
      enabled: true
      scrapeInterval: 30s
      serviceMonitor:
        additionalLabels:
          prometheus: kube-prometheus
        enabled: true
    schedules:
      backup-volumes:
        schedule: '@every 24h'
        template:
          ttl: 720h
          snapshotVolumes: true
          storageLocation: default
    serviceAccount:
      server:
        name: velero
EOF
