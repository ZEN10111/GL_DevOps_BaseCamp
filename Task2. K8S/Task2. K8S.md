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


**4) Prepare two job yaml files:**

   a) One gets content via curl from an internal port (ClusterIP)
   b) Second, get content via curl from an external port (NodePort)
 
 
 **a)  Job_curl_ClusterIP.yml**
 
 [Job_curl_ClusterIP_link](files/Job_curl_ClusterIP.yml)
 
ClusterIP  10.101.152.62
 
 ```
 apiVersion: batch/v1
kind: Job
metadata:
  name: curl-clusterip
spec:
  template:
    spec:
      containers:
      - name: curl
        image: curlimages/curl
        command: ['curl', '10.101.152.62']
      restartPolicy: OnFailure
  backoffLimit: 4
 ```
 
 ```
 kubectl apply -f ./Job_curl_ClusterIP.yml -n devops
 ```
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216821814-2e36337b-3485-4176-b0ac-3837f76f4607.png)
 
 ```
 kubectl get jobs -n devops
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216823691-8b2b40f1-2eb9-44c2-bfa5-57e7deb0533f.png)


 ```
 kubectl logs job.batch/curl-clusterip -n devops
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216821903-62e053b0-a73a-4d39-abc9-de71c27559b3.png)

```
kubectl get pods -n devops
```

![изображение](https://user-images.githubusercontent.com/97990456/216821968-eb78e721-c01b-415b-b352-456ae4bb9ec7.png)


 **b) Job_curl_NodePort.yml**
 
 [Job_curl_NodePort_link](files/Job_curl_NodePort.yml)
 
 ```
 apiVersion: batch/v1
kind: Job
metadata:
  name: curl-nodeport
spec:
  template:
    spec:
      containers:
      - name: curl
        image: curlimages/curl
        command: ['curl', '10.156.0.28:30010']
      restartPolicy: OnFailure
  backoffLimit: 4
 ```

 worker node 10.156.0.28 
 NodePort 30010 
 
 ```
 kubectl apply -f ./Job_curl_NodePort.yml -n devops
 ``` 
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216823793-7abcce34-e6c7-45b4-b69a-1b33209ddef1.png)

 ```
 kubectl get jobs -n devops
 ```
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216823895-f2364a66-bdb9-4c4d-bc68-7843ea40389f.png)
 
 ```
 kubectl logs job.batch/curl-nodeport -n devops
 ```
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216824019-4f347938-f8cd-4db9-ab5c-3d180424c9f6.png)

 
 **5) Prepare Cronjob.yaml file which will test the connection to Nginx or Apache service every 3 minutes.**
 
 I will  test ClusterIP and  NodePort availability of the service
 
 CronJob_NGINX_port_status.yml
 
  [CronJob_NGINX_port_status_link](files/CronJob_NGINX_port_status.yml)
 
 ```
 apiVersion: batch/v1
kind: CronJob
metadata:
  name: nginx-port-status
spec:
  schedule: "*/3 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: nmap
            image: instrumentisto/nmap
            imagePullPolicy: IfNotPresent
            command: 
            - /bin/sh
            - -c
            - echo 'ClusterIP status:'; nmap -p 80 10.101.152.62; echo '---------------------------------------'; echo 'NodePort status:'; nmap -p 30010 10.156.0.28  
          restartPolicy: OnFailure
      backoffLimit: 4
 ```

 ```
  kubectl apply -f ./CronJob_NGINX_port_status.yml -n devops
 ```
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216835608-33e727cf-6e0c-4a16-90b8-62bc24ad6075.png)
 
 ```
 kubectl get CronJob -n devops
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216835659-58b4122c-3e25-4555-83a3-c0c801f3428d.png)


 ```
 kubectl get jobs --watch -n devops
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216835837-689d512c-bd41-4932-a14b-f65fa2a869ff.png)


 ```
 kubectl get pods -n devops
 ```

 ![изображение](https://user-images.githubusercontent.com/97990456/216836033-a2ffda59-5a51-4f70-9481-9298f70f6867.png)

 ```
 kubectl logs nginx-port-status-27926982-p9r9r -n devops
 ```

 ![изображение](https://user-images.githubusercontent.com/97990456/216836144-a82b5989-37bc-4fe8-8a18-bdae1612a40d.png)

