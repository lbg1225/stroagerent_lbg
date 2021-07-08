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
          resources:
            limits:
              cpu: 500m 
            requests:
              cpu: 200m 
          readinessProbe:
            httpGet:
              path: '/actuator/health'
              port: 8080
            initialDelaySeconds: 10
            timeoutSeconds: 2
            periodSeconds: 5
            failureThreshold: 10              
          livenessProbe:
            failureThreshold: 5
            httpGet:
              path: /actuator/health
              port: 8080
              scheme: HTTP
            initialDelaySeconds: 120
            periodSeconds: 5
            successThreshold: 1
            timeoutSeconds: 2
---
apiVersion: v1
kind: Service
metadata:
  name: payment
  namespace: storagerent
  labels:
    app: storage
spec:
  ports:
    - port: 8080
      targetPort: 8080
  selector:
    app: payment
EOF