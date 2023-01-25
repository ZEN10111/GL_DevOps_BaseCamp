**Task 1**

Install docker:

 - nano  install_dosker.sh

```
#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo docker run hello-world

#  Post install: add permision for curent user to run docker commands(need re-login a to apply the new rights)

sudo groupadd docker
sudo usermod -aG docker $USER

echo -e "\nFor curent user $USER need re-login to run docker commands without sudo\n"

```

 - chmod +x install_dosker.sh
 
 - ./install_dosker.sh


 - result :
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214573119-d4447ac1-5cfc-43f6-928d-246aff1c94ec.png)
 ![зображення](https://user-images.githubusercontent.com/97990456/214573244-115eeb5a-5e32-437f-af19-39651538371f.png)
  
 - after re-login curent user:
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214573566-e0404e6e-3c4a-49e9-b528-f6af0d34e812.png)



