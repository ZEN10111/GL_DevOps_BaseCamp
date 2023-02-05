**Home Task k8s part 1**

**1) Get information about your worker node and save it in some file**

```kubectl describe nodes kubenode > worker_node_des.txt```

![изображение](https://user-images.githubusercontent.com/97990456/216445817-d3dbc479-4354-4772-b022-73f83f4d624a.png)

[worker_node_des_link](worker_node_des.txt)


**2) Create a new namespace (all resources below will create in this namespace)**

```kubectl create namespace devops```

![изображение](https://user-images.githubusercontent.com/97990456/216450528-da4fa978-ee90-4326-bec0-65b290c2456a.png)

**3) Prepare deployment.yaml file which will create a Deployment with 3 pods of Nginx or Apache 
     and service for access to these pods via ClusterIP and NodePort.**
 
 Deployment-service.yml
 
 (ClusterIP created by default so we  describe only NodePort)
 
 ```
 apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-server
  template:
    metadata:
      labels:
        app: nginx-server
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80

---

apiVersion: v1
kind: Service
metadata:
  name: nginx-server-service
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: nginx-server
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30010
 ```
 
 [Deployment-service_link](Deployment-service.yml)

```
kubectl apply -f ./Deployment-service.yml -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216794295-a328bd8a-40ce-47a3-a29d-de75ab8abf52.png)


**a) Show the status of deployment, pods and services. Describe all resources which you will create and logs from pods**

```
kubectl get service  -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216794599-a58b4e2c-cd94-49ee-8473-b5a23c1b339c.png)

```
kubectl get pods  -n devops
```
![изображение](https://user-images.githubusercontent.com/97990456/216794671-0891e445-6c01-4d8c-a64d-cb4d135980ef.png)

```
kubectl get services  -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216794723-e9c5e4fe-92d6-4330-83f8-35daf10c7777.png)
