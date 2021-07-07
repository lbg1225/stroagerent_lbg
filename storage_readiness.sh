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
          image: lbg1225/storage:v2
          ports:
            - containerPort: 8080
          resources:
            limits:
              cpu: 2000m
            requests:
              cpu: 1000m
          readinessProbe:
            httpGet:
              path: '/actuator/health'
              port: 8080
            initialDelaySeconds: 10
            timeoutSeconds: 2
            periodSeconds: 5
            failureThreshold: 10              
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
