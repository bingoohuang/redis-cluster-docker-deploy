apiVersion: batch/v1
kind: Job
metadata:
  name: redis-cluster-create
  namespace: redis
spec:
  template:
    spec:
      tolerations:
      - effect: NoSchedule
        key: node-role.kubernetes.io/control-plane
      #nodeSelector:
      #  redis-cluster-create: "yes"
      containers:
      - name: redis-cluster-create
        image: qiushaocloud/bitnami-create-redis-cluster:latest #qiushaocloud/redis-cluster:latest
        imagePullPolicy: Always
        #command: ["/bin/bash"]
        #args: ["-c", "/run-create-cluster.sh"]
        env:
        - name: REDIS_PASSWORD
          value: <REDIS_PASSWORD>
        - name: REDIS_CLUSTER_REPLICAS
          value: "<REDIS_CLUSTER_REPLICAS>"
        - name: REDIS_NODES
          value: <REDIS_NODES>
        - name: ALLOW_USE_DOMAIN
          value: "yes"
      restartPolicy: Never
  backoffLimit: 0
