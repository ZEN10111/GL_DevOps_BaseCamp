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


