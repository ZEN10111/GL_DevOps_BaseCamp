**Home Task k8s part 1**

**1) Get information about your worker node and save it in some file**

```kubectl describe nodes kubenode > worker_node_des.txt```

![изображение](https://user-images.githubusercontent.com/97990456/216445817-d3dbc479-4354-4772-b022-73f83f4d624a.png)

[worker_node_des_link](files/worker_node_des.txt)


**2) Create a new namespace (all resources below will create in this namespace)**

```kubectl create namespace devops```

![изображение](https://user-images.githubusercontent.com/97990456/216450528-da4fa978-ee90-4326-bec0-65b290c2456a.png)

**3) Prepare deployment.yaml file which will create a Deployment with 3 pods of Nginx or Apache 
     and service for access to these pods via ClusterIP and NodePort.**
 
 Deployment-service.yml
 
 (ClusterIP created by default so need  describe only NodePort)
 
 ```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-server
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx-server
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx-server
    spec:
      containers:
      - name: nginx
        image: nginx:stable
        ports:
        - containerPort: 80
          name: http-web-svc


---

apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app.kubernetes.io/name: nginx-server
  ports:
  - name: nginx-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
    nodePort: 30010
 ```
 
 [Deployment-service_link](files/Deployment-service.yml)

```
kubectl apply -f ./Deployment-service.yml -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216797001-49b6f39e-ecb0-4750-9002-2390af6dc1c6.png)


**a) Show the status of deployment, pods and services. Describe all resources which you will create and logs from pods**

```
kubectl get deployment -n devops
```
![изображение](https://user-images.githubusercontent.com/97990456/216797061-ee5f1129-8b15-4d34-8ab2-1eb0dd922dd7.png)

```
kubectl get pods  -n devops
```
![изображение](https://user-images.githubusercontent.com/97990456/216797080-7b80d3a1-8f3f-45dc-b612-f2ce275a64b4.png)

```
kubectl get services  -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216797103-183056f1-d467-4a42-b2e7-e7db40ecef29.png)


```
kubectl get replicaset  -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216797126-1e88e45f-20fb-4436-9682-bbe4ac39b1c4.png)

**Decription:**

I have created a deployment that contains 3 nginx pods and a service that allows access to these nodes via ClusterIP (10.101.152.62) and nodePort( 10.156.0.28:30010 - from the worker node) and replicaset is automatically created

**Logs from pods**

```
kubectl logs nginx-server-868b759c67-bhvd5
```

![изображение](https://user-images.githubusercontent.com/97990456/216797751-adf4fedc-6b07-4938-8bbd-1bab1f2192ed.png)


```
kubectl logs nginx-server-868b759c67-pcrzl -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216797640-afaece39-3e0b-41ce-bf0e-0d49f820b185.png)

```
kubectl logs nginx-server-868b759c67-vks87 -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216797684-859a123f-3f9e-45c3-a14d-983088b0367a.png)


