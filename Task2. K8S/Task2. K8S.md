**Home Task k8s part 1**

**1) Get information about your worker node and save it in some file**

```kubectl describe nodes kubenode > worker_node_des.txt```

![изображение](https://user-images.githubusercontent.com/97990456/216445817-d3dbc479-4354-4772-b022-73f83f4d624a.png)

[worker_node_des_link](worker_node_des.txt)


**2) Create a new namespace (all resources below will create in this namespace)**

```kubectl create namespace devops```

![изображение](https://user-images.githubusercontent.com/97990456/216449593-c684ea9b-24f5-4abb-aa3c-ce5b78f31f8b.png)

