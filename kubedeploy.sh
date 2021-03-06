#!/bin/bash
#------------------------------------------------------------------------------------------
# kubernate 배포 스크립트 Created By 이병관
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
  name: gateway
  namespace: storagerent
  labels:
    app: gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: gateway
  template:
    metadata:
      labels:
        app: gateway
    spec:
      containers:
        - name: gateway
          image: $ECR/gateway:$ver
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: gateway
  namespace: storagerent
  labels:
    app: gateway
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: gateway
  type:
    LoadBalancer
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: message
  namespace: storagerent
  labels:
    app: message
spec:
  replicas: 1
  selector:
    matchLabels:
      app: message
  template:
    metadata:
      labels:
        app: message
    spec:
      containers:
        - name: message
          image: $ECR/message:$ver
          ports:
            - containerPort: 8080
          env:
            - name: superuser.userId
              value: some_value                                 
            - name: _DATASOURCE_ADDRESS
              value: mysql
            - name: _DATASOURCE_TABLESPACE
              value: messagedb
            - name: _DATASOURCE_USERNAME
              value: root
            - name: _DATASOURCE_PASSWORD
              value: admin
---
apiVersion: v1
kind: Service
metadata:
  name: message
  namespace: storagerent
  labels:
    app: message
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: message
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment
  namespace: storagerent
  labels:
    app: payment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: payment
  template:
    metadata:
      labels:
        app: payment
    spec:
      containers:
        - name: payment
          image: $ECR/payment:$ver
          ports:
            - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: payment
  namespace: storagerent
  labels:
    app: payment
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: payment
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reservation
  namespace: storagerent
  labels:
    app: reservation
spec:
  replicas: 1
  selector:
    matchLabels:
      app: reservation
  template:
    metadata:
      labels:
        app: reservation
    spec:
      containers:
        - name: reservation
          image: $ECR/reservation:$ver
          ports:
            - containerPort: 8080
          env:
            - name: prop.storage.url
              valueFrom:
                configMapKeyRef:
                  name: storagerent-config
                  key: prop.storage.url
            - name: prop.payment.url
              valueFrom:
                configMapKeyRef:
                  name: storagerent-config
                  key: prop.payment.url
---
apiVersion: v1
kind: Service
metadata:
  name: reservation
  namespace: storagerent
  labels:
    app: reservation
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: reservation
---
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
          image: $ECR/storage:$ver
          ports:
            - containerPort: 8080
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
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: viewpage
  namespace: storagerent
  labels:
    app: viewpage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: viewpage
  template:
    metadata:
      labels:
        app: viewpage
    spec:
      containers:
        - name: viewpage
          image: $ECR/viewpage:$ver
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: viewpage
  namespace: storagerent
  labels:
    app: viewpage
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: viewpage
EOF
