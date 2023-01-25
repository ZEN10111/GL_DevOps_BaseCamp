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

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Test docker
sudo docker run hello-world

# Post install : add permision  for  curent user  to run  docker  commands

sudo groupadd docker
sudo usermod -aG docker $USER
```

 - chmod +x install_dosker.sh
 
 - ./install_dosker.sh

