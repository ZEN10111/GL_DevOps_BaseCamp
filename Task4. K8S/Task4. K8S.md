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

```
