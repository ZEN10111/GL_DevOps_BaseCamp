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
  - "10.200.0.2/32"
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

