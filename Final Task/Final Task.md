
**1. Terraform:**

  - create VPC in GCP/Azure	
  - create instance with External IP	
  - prepare managed DB (MySQL)	



![зображення](https://user-images.githubusercontent.com/97990456/219986199-347a8b3e-4358-486f-a3fe-23dce3272165.png)


**2. Ansible:**	

  - perform basic hardening (keyless-only ssh, unattended upgrade, firewall)
  - (optional) perform hardening to reach CIS-CAT score at least 80 (please find https://learn.cisecurity.org/cis-cat-lite)
  - deploy K8s (single-node cluster via Kubespray)



 perform basic hardening (keyless-only ssh, unattended upgrade, firewall)





 **Clone Kubespray release repository**
 
 ```
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
git checkout release-2.20
 ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/219468352-b3c68fed-73ed-474e-be4b-6d1b2c055ec8.png)
 
 
 **Copy and edit inventory file*
 
 ```
 cp -rfp inventory/sample inventory/mycluster
 ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/219468801-1818c3cf-f508-44f3-8c8c-005a6ffd6abd.png)

```
 nano inventory/mycluster/inventory.ini
```


![зображення](https://user-images.githubusercontent.com/97990456/219469751-4afaadb4-b764-48cc-b97f-cebc26ad6466.png)


**Turn on MetalLB**

```
nano inventory/mycluster/group_vars/k8s_cluster/addons.yml
```

```
metallb_enabled: true
metallb_speaker_enabled: true
metallb_ip_range:
 - "10.2.0.2/32"
metallb_avoid_buggy_ips: true
```

```
nano inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
```

```
kube_proxy_strict_arp: true
```


**Run execute container**


```
docker run --rm -it -v /home/zen/hometask_final/Ansible/:/mnt   -v /home/zen/.ssh:/pem   quay.io/kubespray/kubespray:v2.20.0 bash
```

![зображення](https://user-images.githubusercontent.com/97990456/219472875-40353608-56a2-4b93-a014-c8e43085d81a.png)


**Go to kubespray folder and start ansible-playbook**

```
cd /mnt/kubespray
```

![зображення](https://user-images.githubusercontent.com/97990456/219473199-14032523-9489-43dc-8b38-5516d912a280.png)

```
ansible-playbook -i inventory/mycluster/inventory.ini --private-key /pem/id_rsa -e ansible_user=zen -b  cluster.yml
```

![зображення](https://user-images.githubusercontent.com/97990456/219480701-bfab8370-1f50-4468-a1c6-90a328a17638.png)


**After successful installation create  and  run ansible  playbook**

with roles:

 - copy config file
 - install software
 - Get Cluster information


install  kubernetes.core collection 

```
ansible-galaxy collection install kubernetes.core
```


```
ansible-playbook initialization_cluster.yml  --private-key ~/.ssh/id_rsa
```

![зображення](https://user-images.githubusercontent.com/97990456/219787115-2bb197af-3746-479a-a6dd-dd08e4818ddf.png)



**3. Kubernetes:**
  - prepare ansible-playbook for deploying Wordpress
  - deploy WordPress with connection to DataBase



create  and  run ansible  playbook prepare_cluster

```
ansible-playbook prepare_cluster.yml  --private-key ~/.ssh/id_rsa
```

   prepare_cluster
   
    - install ingress controller
    - install path_provisioner
    - install cert-manager
    - install ClusterIssuer


![зображення](https://user-images.githubusercontent.com/97990456/219986484-d2808cf5-30a9-4b98-b60d-9a32716ac11a.png)


