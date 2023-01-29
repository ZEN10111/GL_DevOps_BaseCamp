**Setup Kubernetes Cluster**

1 Prepare kubemaster and kubenode VMs with the same parametrs:
 (4 CPU. 8 GB RAM, Ubuntu (only for this task)_

- kubemaster
 
  ![изображение](https://user-images.githubusercontent.com/97990456/215341643-40d38bcb-223a-4351-804c-6affcfb9dce0.png)    
  ![изображение](https://user-images.githubusercontent.com/97990456/215334414-58c44294-6af3-40e0-befb-accca813a3a4.png)


 - kubenode

  ![изображение](https://user-images.githubusercontent.com/97990456/215343342-915c21aa-015c-4cac-899c-bb11c05b2bd7.png)
  ![изображение](https://user-images.githubusercontent.com/97990456/215334753-8255aa45-b263-417e-9ad8-d18fe6478159.png)


2 VM-s

![изображение](https://user-images.githubusercontent.com/97990456/215343410-3dc041da-1d8d-4d2e-aed4-2e2c3af93886.png)


SSH to VM-s

![изображение](https://user-images.githubusercontent.com/97990456/215343988-4dc8a47c-7cd2-474d-8ea9-dd74f265eff9.png)


**2.	Run commands in two VMs (kubemaster and kubenode)**

```
sudo apt update
sudo apt upgrade -y
```
reult  of two  comands

![изображение](https://user-images.githubusercontent.com/97990456/215345506-29bd7949-91a0-4654-9fe6-a7a1eeefcf43.png)

Edit the hosts file with the command:

```sudo nano /etc/hosts```

Put your private IP address and hostname

![изображение](https://user-images.githubusercontent.com/97990456/215345875-cadfa7e7-3d35-43b5-bfb2-59913b863209.png)

Install the first dependencies with:

```sudo apt install curl apt-transport-https -y```

![изображение](https://user-images.githubusercontent.com/97990456/215346003-36a76fe6-d02c-46c4-bd51-e7de8268368b.png)

Next, add the necessary GPG key with the command:

```curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -```

![изображение](https://user-images.githubusercontent.com/97990456/215346173-95ebb069-e77f-4402-9b24-1c383be345c2.png)

Add the Kubernetes repository with:

```echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list```

![изображение](https://user-images.githubusercontent.com/97990456/215346224-3a586263-592b-4b3d-848a-2fcb26a4e612.png)

Update apt:

```sudo apt update``

![изображение](https://user-images.githubusercontent.com/97990456/215346295-dc709ddb-5e9b-4eba-9206-157cdc01bb6a.png)

Install the required software with the command:

```sudo apt -y install vim git curl wget kubelet kubeadm kubectl```

![изображение](https://user-images.githubusercontent.com/97990456/215346415-b9fc879c-5bf5-4fa5-87cd-1241d6e33cc4.png)

Place kubelet, kubeadm, and kubectl on hold with:

```sudo apt-mark hold kubelet kubeadm kubectl```

![изображение](https://user-images.githubusercontent.com/97990456/215346477-c78a99c7-4f6e-4a0e-a127-b53facabc82e.png)

Start and enable the kubelet service with:

```sudo systemctl enable --now kubelet```

![изображение](https://user-images.githubusercontent.com/97990456/215346621-1f4cb42a-dee5-4a5c-be9d-4c60ae7a3782.png)

Next, we need to disable swap on both kubemaster. Open the fstab file for editing with:

```sudo nano /etc/fstab```

Save and close the file. You can either reboot to disable swap or simply issue the following command to finish up the job:

```sudo swapoff -a```

in our case, virtual machines do not have a swap partition

![изображение](https://user-images.githubusercontent.com/97990456/215347431-62d501e9-a324-4ba1-ac35-2f2d1661e733.png)


Enable Kernel Modules and Change Settings in sysctl:

```
sudo modprobe overlay
sudo modprobe br_netfilter
```

![изображение](https://user-images.githubusercontent.com/97990456/215347706-8d18dd8c-2fef-4261-b15c-414215e76b37.png)

Change the sysctl settings by opening the necessary file with the command:

```sudo nano /etc/sysctl.d/kubernetes.conf```

Look for the following lines and make sure they are set as you see below:

```
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
```

![изображение](https://user-images.githubusercontent.com/97990456/215347842-f196878d-a63e-46d5-833e-f68b57950bf9.png)

Save and close the file. Reload sysctl with:

```sudo sysctl --system```

![изображение](https://user-images.githubusercontent.com/97990456/215347940-1d588be4-f431-4c9d-acf5-e323ffc154e9.png)

**Install containerd**

Install the necessary dependencies with:

```sudo apt install curl gnupg2 software-properties-common apt-transport-https ca-certificates -y```

![изображение](https://user-images.githubusercontent.com/97990456/215348163-e8e770b7-6806-4087-b3fd-f288c995f2c6.png)

Add the GPG key with:

```curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -```

![изображение](https://user-images.githubusercontent.com/97990456/215348239-c26e81f8-a02c-40eb-aa33-47ad81fed591.png)

Add the required repository with:

```sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"```

![изображение](https://user-images.githubusercontent.com/97990456/215348314-eaa223d4-3c4e-4483-ac09-8ec1d895dbfb.png)

Install containerd with the commands:

```
sudo apt update
sudo apt install containerd.io -y

```

![изображение](https://user-images.githubusercontent.com/97990456/215348420-b02ef5d1-ce56-496f-b335-cc30e5cc0027.png)


Change to the root user with:

```sudo su```

![изображение](https://user-images.githubusercontent.com/97990456/215348697-96153d51-f8fb-4e07-8ed9-675c2e24f0d7.png)

Create a new directory for containerd with:

```mkdir -p /etc/containerd```

![изображение](https://user-images.githubusercontent.com/97990456/215348863-6020d2e3-ef59-45ef-8acc-cf5fb0b4a7eb.png)


Generate the configuration file with:

```containerd config default>/etc/containerd/config.toml```

![изображение](https://user-images.githubusercontent.com/97990456/215349215-e5f9ba37-19aa-46ce-b9d0-21c4f6f2cb6b.png)

Exit from the root user with:

```exit```

![изображение](https://user-images.githubusercontent.com/97990456/215349260-85474ffa-c5bf-44e4-b130-ba6997c837c0.png)


Restart containerd with the command:

```sudo systemctl restart containerd```

![изображение](https://user-images.githubusercontent.com/97990456/215349314-25a86bab-6b8a-4a6a-8427-896951ef3b6d.png)

Enable containerd to run at startup with:

```sudo systemctl enable containerd```

![изображение](https://user-images.githubusercontent.com/97990456/215349464-c53796b9-3bb6-478f-a9bd-000ce6bb461a.png)

**Initialize the Master Node**

Pull down the necessary container images with:

```sudo kubeadm config images pull```

![изображение](https://user-images.githubusercontent.com/97990456/215349632-4033eb19-3d4d-4d6f-923a-44b477a89efd.png)

**Command only for kubemaster :**

Now, using the kubemaster IP address initialize the master node with:

```sudo kubeadm init --pod-network-cidr=192.168.0.0/16```

![изображение](https://user-images.githubusercontent.com/97990456/215349773-0671c70e-6baf-4f52-a723-65ed494408c3.png)

Finally, you need to create a new directory to house a configuration file and give it the proper permissions which is done with the following commands:

```
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

![изображение](https://user-images.githubusercontent.com/97990456/215349878-7da6e952-85d4-466d-937e-7f8a17e501d2.png)


List Kubernetes Nodes:

```kubectl get nodes```

![изображение](https://user-images.githubusercontent.com/97990456/215350098-a4402bc9-1f37-471a-885d-c40a043e5a56.png)


**Command only for kubenode :**

Connect kubenode to kubemaster

```
sudo su
```

```
kubeadm join 10.156.0.27:6443 --token 2nq14z.2jbuwvi1eo2nt6wb \
        --discovery-token-ca-cert-hash sha256:5767a28caad3b519a6d517ee61a797b0449b37fdb33b6578d52a1cc7ab1942ce
```
(copy from kubemaster output)

![изображение](https://user-images.githubusercontent.com/97990456/215350327-a31e7dee-2241-4d11-a05d-89a14321f9c9.png)


**Comeback to kubemaster :**

Install network:

```
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml -O

kubectl create -f custom-resources.yaml

```
![изображение](https://user-images.githubusercontent.com/97990456/215350525-b30003b4-9c16-46b6-b6ba-207769d1a58a.png)

![изображение](https://user-images.githubusercontent.com/97990456/215350577-82a6b9ef-f403-4f77-8156-d90d9e3eb4f6.png)

![изображение](https://user-images.githubusercontent.com/97990456/215350629-ecf7dd31-8dc2-4060-880d-76978741fd13.png)


Wait when all pods will be ready:

```kubectl get pods --all-namespaces -w```

![изображение](https://user-images.githubusercontent.com/97990456/215350711-6ae97786-246a-41ce-97a9-14f33dd51113.png)


**Result:**

```kubectl get nodes -o wide```

![изображение](https://user-images.githubusercontent.com/97990456/215350830-4ae13655-4887-48b8-8ca6-43267c55e396.png)


**Successfully deployed Kubernetes**

**Advanced**

Add  ROLES label to  worker  node

```kubectl label node kubenode node-role.kubernetes.io/worker=worker```

![изображение](https://user-images.githubusercontent.com/97990456/215352888-6c04177d-0459-4ed9-997c-a95f045faabc.png)




