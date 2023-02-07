**Kubernetes2 Home Task**

**Task 1**

**1-2. Create VM-Configure VM**

![изображение](https://user-images.githubusercontent.com/97990456/216844811-813e2bde-f654-49f2-9355-0a0ec1971c22.png)

![изображение](https://user-images.githubusercontent.com/97990456/216844976-9107fdd9-0a13-4ae3-996e-61e2a8a655c8.png)

**3. Add SSH public key**

![изображение](https://user-images.githubusercontent.com/97990456/216845182-454d4848-6d41-474a-bc23-a70a81d37226.png)

**4. Test SSH connection from local machine**

 ```
 ssh 34.140.160.128
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216845428-d816dd53-0f5a-4b3e-88ff-fbf7362f6063.png)

**5. Clone Kubespray release  repository**

 ```
 git clone https://github.com/kubernetes-sigs/kubespray.git
 cd kubespray
 git checkout release-2.20
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216848705-73543da2-c2f3-4759-b81d-5ba5ae60ab9f.png)

**6. Copy and edit inventory file**

```
cp -rfp inventory/sample inventory/mycluster
```

![изображение](https://user-images.githubusercontent.com/97990456/216849266-e698e74e-5bd9-4c89-ae91-42e35b95d6e6.png)

```
[all]
node1 ansible_host=34.140.160.128
[kube_control_plane]
node1

[etcd]
node1

[kube_node]
node1

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr
```

**7. Turn on MetalLB**

 ```
 nano inventory/mycluster/group_vars/k8s_cluster/addons.yml
 ```

 ```
 metallb_enabled: true
 metallb_speaker_enabled: true
 metallb_ip_range:
  - "10.132.0.2/32"
 metallb_avoid_buggy_ips: true
 ```

 ```
 nano inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
 ```
 
 ```
 kube_proxy_strict_arp: true
 ```
 
**8. Run execute container**

 ```
 docker run --rm -it -v /home/zen/hometask13:/mnt   -v /home/zen/.ssh:/pem   quay.io/kubespray/kubespray:v2.20.0 bash
 ```
 
 ![изображение](https://user-images.githubusercontent.com/97990456/216852985-1911d512-b709-4750-a9c1-7cf78d95ea2d.png)
 
 **9. Go to kubespray folder and start ansible-playbook**
 
 ```
 cd /mnt/kubespray
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216853115-afdf1138-52e8-4656-8e94-15dadea08088.png)

 ```
 ansible-playbook -i inventory/mycluster/inventory.ini --private-key /pem/id_rsa -e ansible_user=zen -b  cluster.yml
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216856731-3c992b4e-ab6c-48b1-8024-38be15b143e2.png)


**10. After successful installation connect to VM and copy kubectl configuration file.**

 ```
 ssh -i /pem/id_rsa zen@34.140.160.128
 ```

![изображение](https://user-images.githubusercontent.com/97990456/216857259-87d84acb-15bd-4743-8c88-a5292d7e2fc4.png)

 ```
 mkdir ~/.kube
 sudo cp /etc/kubernetes/admin.conf ~/.kube/config
 sudo chmod 777 ~/.kube/config
 kubectl get nodes
 ```
![изображение](https://user-images.githubusercontent.com/97990456/216857469-9a4bc82c-3fe0-4009-b8fb-2d1a8ecb7142.png)


**11. As result, you will see installed node**

 ```
 kubectl get ns
 kubectl get nodes
 ```
![изображение](https://user-images.githubusercontent.com/97990456/216857769-531e3672-4e12-4105-ad85-0073c3674016.png)

**Task 2**

**1. Install Ingress-controller**

 ```
 kubectl apply -f nginx-ctl.yaml
 ```

![зображення](https://user-images.githubusercontent.com/97990456/216997140-2c964535-fa29-4ed5-aabe-2a2444d8d33d.png)

 ```
 kubectl apply -f path_provisioner.yaml
 ```

![зображення](https://user-images.githubusercontent.com/97990456/216998669-407e7890-4441-4442-90bf-953961ac085d.png)


 ```
 kubectl get pods -n ingress-nginx -w
 ```

![зображення](https://user-images.githubusercontent.com/97990456/216999046-ce066dfc-5d30-41af-9267-cbda422a72d1.png)


 ```
 kubectl get svc --all-namespaces
 ```
 

![зображення](https://user-images.githubusercontent.com/97990456/217249038-b0561ef5-82d8-4f0f-afd9-458a071e8ac4.png)

**Task 3**

**1. Prepare domain name (free resource https://dynv6.com/ )**

 ```
 esemerenko.dns.navy 
 ```

![зображення](https://user-images.githubusercontent.com/97990456/217249646-59c3bec8-fc28-4572-8189-624b24530600.png)


**2.	Configure cert-manager (https://cert-manager.io/) with Letsencrypt.**


Deploy cert-manager

 ```
 kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml
 ```

![изображение](https://user-images.githubusercontent.com/97990456/217093145-0ab923ce-2b7e-44da-8f2f-a317490c749d.png)



Deploy   ClusterIssuer

[ClusterIssuer_link](files/ClusterIssuer.yml)

ClusterIssuer.yml

```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
   # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: zen002@ukr.net
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
       # Enable the HTTP-01 challenge provider
    solvers:
      - http01:
         ingress:
           class: nginx
```

![зображення](https://user-images.githubusercontent.com/97990456/217255096-4d955414-e1a8-4b5e-a78f-e6a523644670.png)

 ```
 kubectl get Clusterissuer
 ```

![зображення](https://user-images.githubusercontent.com/97990456/217256680-2656e9e3-46f0-46c3-b46d-3cabf2f17cd8.png)


**Task 4**

**1. Prepare Nginx deployment:
      - Deployment
      - Service
      - Ingress (which will be connected to ClusterIssuer and use the letsencrypt certificate)

Deployment-service-ingess.yml

[Deployment-service-ingess_link](files/Deployment-service-ingess.yml)

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
  selector:
    app.kubernetes.io/name: nginx-server
  ports:
  - name: nginx-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
---


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-service
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: "letsencrypt-prod"

spec:
  tls:
  - hosts:
    - esemerenko.dns.navy
    secretName: quickstart-example-tls
  rules:
  - host: esemerenko.dns.navy
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
```

Deploy Deployment-service-ingess

```
kubectl apply -f Deployment-service-ingess.yml
```

![зображення](https://user-images.githubusercontent.com/97990456/217252654-04bcce16-b7db-406e-ac28-a3738a7a3093.png)


```
kubectl get Deployment
kubectl get services
kubectl get ingress
```

![зображення](https://user-images.githubusercontent.com/97990456/217257409-eae51112-96f2-4b1c-be44-3f7e70259c25.png)


go to site  esemerenko.dns.navy

![зображення](https://user-images.githubusercontent.com/97990456/217259784-d6d44250-8991-4efc-906d-d05870534da6.png)


```
kubectl get certificate
```

![зображення](https://user-images.githubusercontent.com/97990456/217261013-7e30bd20-23df-4951-b8eb-5e6b8228d181.png)


```
kubectl describe certificate quickstart-example-tls
```

![зображення](https://user-images.githubusercontent.com/97990456/217261993-8f3e5111-f2ff-4d1a-8907-157227b0a652.png)
