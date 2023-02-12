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


**Task 2**

**2. Create and deploy your own chart with the Pacman ( https://hub.docker.com/r/golucky5/pacman ) game. 
     ( https://helm.sh/docs/chart_template_guide/getting_started/ )**

expected result:

![зображення](https://user-images.githubusercontent.com/97990456/217721011-040016a3-2e5e-485f-8468-b34aeffbfce4.png)


Pac-man is based on nginx, so we only need to update images and other variables if we want


**we can do this in two ways:**

 -  install  priverios chart, but set another name and  pacman`s image  ```golucky5/pacman``` and  another dns pac-man.dns.navy

  ```
   helm install pac-man  nginx-server/ --set container.image=golucky5/pacman --set dnsName=pac-man.dns.navy
   
  ```
  
  ![зображення](https://user-images.githubusercontent.com/97990456/217722675-50af967e-1775-4c9b-8ba8-e129890fd6c2.png)


```
helm ls
```

![зображення](https://user-images.githubusercontent.com/97990456/217731799-366572d0-ba6c-459c-8b31-d7f3a969b458.png)


Go  to site ```pac-man.dns.navy```


![зображення](https://user-images.githubusercontent.com/97990456/217732081-e8b0dde2-9957-43f9-ba8c-843fb467a73e.png)



**or second way:**

  - copy and  update  priverios chart files
  
```
mkdir pac-man
cp -R nginx-server/* pac-man/
```

![зображення](https://user-images.githubusercontent.com/97990456/217733001-e53812b3-e84a-4618-8a09-32d04a6eee3e.png)

[pac-man_Helm_chart_ link](files/pac-man/)

[values.yaml_link](files/pac-man/values.yaml)


nano pac-man/values.yaml

```
# Default Valuev  for helm chart

container:
  image: golucky5/pacman

replicaCount: 3

dnsName: pac-man.dns.navy
```

install  Helm chart

```
 helm install pac-man  pac-man/
```

![зображення](https://user-images.githubusercontent.com/97990456/217733904-a6ac0777-a009-47a1-8479-b053ce2badd3.png)


Go  to site ```pac-man.dns.navy```

![зображення](https://user-images.githubusercontent.com/97990456/217734039-c1635ed3-12f4-4702-8d4e-96f4b0615145.png)


**Extra Task 3 (not mandatory)**

**Deploy MERN stack (MongoDB, Express.js, React.js, Node.js) via helm**


1 . Downloading the mern-stack 

```
git clone https://github.com/nodeshift/mern-workshop.git
mkdir my-mern
cp -R mern-workshop/* my-mern/
```

```
 ls -la  my-mern/
```

![зображення](https://user-images.githubusercontent.com/97990456/218237077-01c4298d-2b44-40b3-8b24-903dbccf6759.png)

 
 2 . log in  into  gitlab.com
 
 ```
 docker login registry.gitlab.com
 ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/218237110-8fd17743-422e-4dd1-9774-cb5eab55888c.png)

3. create and push  backend container  into  gitlab repository:
 

 
 ```
 cd backend/
 ```
 
 Dockerfile
 
 ```
 # Install the app dependencies in a full Node docker image
FROM node:12

WORKDIR "/app"

# Install OS updates
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get clean \
 && echo 'Finished installing dependencies'

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install --production

# Copy the dependencies into a Slim Node docker image
FROM node:12-slim

WORKDIR "/app"

# Install OS updates
RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get clean \
 && echo 'Finished installing dependencies'

# Install app dependencies
COPY --from=0 /app/node_modules /app/node_modules
COPY . /app

ENV NODE_ENV production
ENV PORT 30555


EXPOSE 30555
CMD ["npm", "start"]
 ```
 
 ```
 docker build -t registry.gitlab.com/devops6485606/backend .
 ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/218237289-9dec880a-047e-4701-ac3d-c9dada56e2fb.png)

 ```
 docker push registry.gitlab.com/devops6485606/backend
 ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/218237331-dacaf157-a1de-497f-b816-bc233c09edec.png)
 
 ![зображення](https://user-images.githubusercontent.com/97990456/218237990-359e8890-b0f0-4653-98ef-127932ec7aef.png)
 
 4.  create and push  frontend container  into  gitlab repository:
 
 ```
 cd ..
 cd frontend/
 ```

 Dockerfile
 
 ```
 ### STAGE 1: Build ###
FROM node:12 as build
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent
RUN npm install react-scripts -g --silent
COPY . /usr/src/app
RUN npm run build

### STAGE 2: Production Environment ###
FROM nginx:1.16.1-alpine
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
 ```

```
docker build -t registry.gitlab.com/devops6485606/frontend .
```

![зображення](https://user-images.githubusercontent.com/97990456/218238016-a9dc2e2e-a2b3-48c4-86c8-ffa2d80fec0e.png)

```
docker push registry.gitlab.com/devops6485606/frontend
```

![зображення](https://user-images.githubusercontent.com/97990456/218238101-4c5b3c48-472c-4d23-a0e1-6c3e39948f11.png)


![зображення](https://user-images.githubusercontent.com/97990456/218238134-6f23f547-d66c-49b6-9459-accdef3c3588.png)



5. Create secret with gitlab credentials

```
kubectl create secret docker-registry gitlab --docker-server=registry.gitlab.com --docker-username=<username> --docker-password=<docker-password>
```

6. modify chart backend files

backend

[backend/values.yaml_link](files/my-mern/backend/chart/backend/values.yaml)

```
nano backend/chart/backend/values.yaml
```

```
replicaCount: 1
revisionHistoryLimit: 1
image:
  repository: registry.gitlab.com/devops6485606/backend
  tag: latest
  pullPolicy: IfNotPresent
  resources:
    requests:
      cpu: 200m
      memory: 300Mi
livenessProbe:
  initialDelaySeconds: 30
  periodSeconds: 10
service:
  name: backend
  type: ClusterIP
  servicePort: 30555
services:
  mongo:
     url: mongo-mongodb
     name: todos
     env: production

dnsName: esemerenko.dns.navy
```

[deployment.yamll_link](files/my-mern/backend/chart/backend/templates/deployment.yaml)

```
nano backend/chart/backend/templates/deployment.yaml
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  labels:
    chart: backend
spec:
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        livenessProbe:
          httpGet:
            path: /health
            port: {{ .Values.service.servicePort }}
          initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds}}
          periodSeconds: {{ .Values.livenessProbe.periodSeconds}}
        ports:
        - containerPort: {{ .Values.service.servicePort}}
        env:
          - name: PORT
            value : "{{ .Values.service.servicePort }}"
          - name: APPLICATION_NAME
            value: "{{ .Release.Name }}"
          - name: MONGO_URL
            value: {{ .Values.services.mongo.url }}
          - name: MONGO_DB_NAME
            value: {{ .Values.services.mongo.name }}
      imagePullSecrets:
       - name: gitlab
```

[service.yaml_link](files/my-mern/backend/chart/backend/templates/service.yaml)

```
nano backend/chart/backend/templates/service.yaml
```


```
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: 'true'
  name: backend
spec:
  ports:
  - name: http
    targetPort: {{ .Values.service.servicePort }}
    port: 30555
  type: ClusterIP
  selector:
    app: backend
```

[Ingess.yaml_link](files/my-mern/backend/chart/backend/templates/Ingess.yaml)

```
nano backend/chart/backend/templates/Ingess.yaml
```

```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backend
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  tls:
  - hosts:
    - {{ .Values.dnsName }}
    secretName: quickstart-example-tls
spec:
  rules:
  - host: {{ .Values.dnsName }}
    http:
      paths:
      - path: /api/todos
        pathType: Prefix
        backend:
          service:
            name: backend
            port:
              number: 30555
```

7. modify chart frontend files

[frontend/values.yaml_link](files/my-mern/frontend/chart/frontend/values.yaml)

```
nano frontend/chart/frontend/values.yaml
```

```
replicaCount: 1
revisionHistoryLimit: 1
image:
  repository: registry.gitlab.com/devops6485606/frontend
  tag: latest
  pullPolicy: IfNotPresent
  resources:
    requests:
      cpu: 200m
      memory: 300Mi
livenessProbe:
  initialDelaySeconds: 30
  periodSeconds: 10
service:
  name: frontend
  type: ClusterIP
  servicePort: 80 # the port where nginx serves its traffic

dnsName: esemerenko.dns.navy
```

[deployment.yaml_link](files/my-mern/frontend/chart/frontend/templates/deployment.yaml)

```
nano frontend/chart/frontend/templates/deployment.yaml
```

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  labels:
    chart: frontend
spec:
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        livenessProbe:
          httpGet:
            path: /
            port: {{ .Values.service.servicePort }}
          initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds}}
          periodSeconds: {{ .Values.livenessProbe.periodSeconds}}
        ports:
        - containerPort: {{ .Values.service.servicePort}}
      imagePullSecrets:
       - name: gitlab
``


[service.yaml_link](files/my-mern/frontend/chart/frontend/templates/service.yaml)`

```
nano frontend/chart/frontend/templates/service.yaml
```

```
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: 'true'
  name: frontend
spec:
  ports:
  - name: http
    targetPort: {{ .Values.service.servicePort }}
    port: 30444
  type: ClusterIP
  selector:
    app: frontend
```
[Ingess.yaml_link](files/my-mern/frontend/chart/frontend/templates/Ingess.yaml)`

```
nano frontend/chart/frontend/templates/Ingess.yaml
```


```
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: frontend
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
            name: frontend
            port:
              number: 30444
```


8 . install mern


```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install mongo --set auth.enabled=false,replicaSet.enabled=true,service.type=ClusterIP,replicaSet.replicas.secondary=1 bitnami/mongodb
helm install backend backend/chart/backend
helm install frontend frontend/chart/frontend

```


Go to frontend

```
https://esemerenko.dns.navy/
```

![зображення](https://user-images.githubusercontent.com/97990456/218340328-5f385f85-c5d2-44f2-9871-be99c06be742.png)


Go to backend

```
https://esemerenko.dns.navy/api/todos
```

![зображення](https://user-images.githubusercontent.com/97990456/218340387-c58233e5-b201-4863-ab78-7fd342e6da7b.png)



