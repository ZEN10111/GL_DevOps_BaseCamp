
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


**deploy K8s (single-node cluster via Kubespray)**

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

create  and  run ansible  playbook helm_install_wordpress

```
ansible-playbook helm_install_wordpress.yml --private-key ~/.ssh/id_rsa
```

![зображення](https://user-images.githubusercontent.com/97990456/220732953-8145397c-69f1-4e85-94a6-b276e32aacd9.png)


go to site:

![зображення](https://user-images.githubusercontent.com/97990456/220729164-e0762f41-491a-49e5-8192-74758dfddedd.png)

