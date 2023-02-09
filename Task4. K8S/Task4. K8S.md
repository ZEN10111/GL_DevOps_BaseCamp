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

![зображення](https://user-images.githubusercontent.com/97990456/217718016-712f2c8e-450e-43a3-b08e-427f3c498935.png)

```
helm ls
```

![зображення](https://user-images.githubusercontent.com/97990456/217718147-d2cc3ad4-2e4f-4abd-bd8a-5f8c8fc96729.png)


Go to site ```https://esemerenko.dns.navy/```

![зображення](https://user-images.githubusercontent.com/97990456/217713694-9a9a5f47-9803-4c71-8960-09b3c161ba84.png)


```
kubectl get deployments
kubectl get services
kubectl get ingress
kubectl get pods
```

![зображення](https://user-images.githubusercontent.com/97990456/217718341-85363e6a-4459-4c8f-90c5-75748ed14400.png)


**Update Chart: add  one pod  and  change domain  to ```web1.zen.dp.ua```**


```
helm upgrade --install --atomic nginx-server nginx-server/ --set replicaCount=4 --set dnsName=web1.zen.dp.ua
```

![зображення](https://user-images.githubusercontent.com/97990456/217719687-4c200613-5a60-4ae6-89ea-426464d72b52.png)


```
kubectl get pods
```

![зображення](https://user-images.githubusercontent.com/97990456/217718722-ad472ca1-509f-40ec-b9c0-559e11c39dff.png)


Go to site ```web1.zen.dp.ua```

![зображення](https://user-images.githubusercontent.com/97990456/217720340-3352f7d2-80c2-40db-a458-5385c24375d9.png)

