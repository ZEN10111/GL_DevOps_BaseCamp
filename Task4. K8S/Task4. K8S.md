**Kubernetes Helm Home Task**

**Task 1**

1.Deploy Nginx via helm with Ingress configuration 
  - Set variables via value yaml
  - Use “helm upgrade --install --atomic …” to change some parameters (Example: number of pods)

install  helm 

```
sudo snap install helm --classic
```

![зображення](https://user-images.githubusercontent.com/97990456/217674310-b8e87174-feba-4f6c-92bd-5cb215339ffe.png)


Create  Helm chart ```nginx-server```


![зображення](https://user-images.githubusercontent.com/97990456/217709982-156358f6-faef-4cc8-9bb2-240d89758f94.png)

nginx-server/Chart.yaml

[Chart.yaml_link](files/nginx-server/Chart.yaml)

```
name       : Nginx-HelmChart
description: My Helm chart for Kubernetes
type       : application
version    : 0.1.0   # This is the Helm Chart version
appVersion : "1.0.0" # This is the version of the application being deployed

keywords:
  - nginx
  - http
  - https
  - esemerenko

maintainers:
  - name : Yevhenii Semerenko
```
nginx-server/values.yaml

[values.yaml_link](files/nginx-server/values.yaml)

```
# Default Valuev  for helm chart

container:
  image: nginx:latest

replicaCount: 3

dnsName: esemerenko.dns.navy

```

nginx-server/templates/Deployment.yaml

[Deployment.yaml_link](files/nginx-server/templates/Deployment.yaml)


```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Release.Name }}
  labels:
    app: {{ .Release.Name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .Release.Name }}
    spec:
      containers:
      - name: {{ .Release.Name }}
        image: {{ .Values.container.image }}
        ports:
        - containerPort: 80
          name: http-web-svc

```


nginx-server/templates/Service.yaml

[Service.yaml_link](files/nginx-server/templates/Service.yaml)

```
apiVersion: v1
kind: Service
metadata:
  name: {{.Release.Name }}
spec:
  selector:
    app.kubernetes.io/name: {{.Release.Name }}
  ports:
  - name: nginx-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc

```

nginx-server/templates/Ingess.yaml

[Ingess.yaml_link](files/nginx-server/templates/Ingess.yaml)

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{.Release.Name }}
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: "letsencrypt-prod"

spec:
  tls:
  - hosts:
    - {{ .Values.dnsName }}
    secretName: quickstart-example-tls
  rules:
  - host: {{ .Values.dnsName }}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: {{.Release.Name }}
            port:
              number: 80
```

Install Helm chart

```
helm install nginx-server nginx-server/
```


![зображення](https://user-images.githubusercontent.com/97990456/217713389-932f2e33-25a8-4540-b1c2-007c38d67636.png)

```
helm ls
```

![зображення](https://user-images.githubusercontent.com/97990456/217714400-192e382a-f834-4df7-9534-17933579da85.png)


Go to site ```https://esemerenko.dns.navy/```

![зображення](https://user-images.githubusercontent.com/97990456/217713694-9a9a5f47-9803-4c71-8960-09b3c161ba84.png)


```
kubectl get deployments
kubectl get services
kubectl get ingress
kubectl get pods
```

![зображення](https://user-images.githubusercontent.com/97990456/217714142-f5103b50-81f7-42f7-98b5-fab008b21f83.png)
