!/bin/bash
#------------------------------------------------------------------------------------------
# auto scale 배포 스크립트 Created By 이병관
#------------------------------------------------------------------------------------------
#-- ECR정보
ECR=739063312398.dkr.ecr.ap-northeast-2.amazonaws.com
ver=v1                                        #-- 기본버전은 v1

if [ $# -gt 0 ] 
then
    ver=$1                                    #-- 버전정보만 입력시 ./build.sh v2  
fi

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: storage
  namespace: storagerent
  labels:
    app: storage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: storage
  template:
    metadata:
      labels:
        app: storage
    spec:
      containers:
        - name: storage
          image: lbg1ECR225/storage:$ver
          ports:
            - containerPort: 8080
          resources:
            limits:
              cpu: 500m 
            requests:
              cpu: 200m 
---
apiVersion: v1
kind: Service
metadata:
  name: storage
  namespace: storagerent
  labels:
    app: storage
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: storage
EOF