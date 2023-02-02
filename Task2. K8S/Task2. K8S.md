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
