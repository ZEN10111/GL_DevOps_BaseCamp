**Task 1**

**Install docker:**

 - nano  install_dosker.sh

install_dosker.sh: 
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

**Prepare a dockerfile based on Apache or Nginx image and 
Added your own index.html page with my name and surname to the docker image**

 - Get own  site files from github(site contains my name) :

   - git clone https://github.com/ZEN10111/site.git

   ![зображення](https://user-images.githubusercontent.com/97990456/214716128-efdc2d10-6bcc-4b59-a6d1-cfcdc017464c.png)


 - enter into site directory and watch files :
   - cd site
   - ls -la
  
   ![зображення](https://user-images.githubusercontent.com/97990456/214716975-4fb3e1f9-5916-4b24-9a66-2f36fd1b2449.png)
 
 - make .dockerignore file ( to ignore files that are not needed in the image):
   - echo '.git' > .dockerignore
 
 - make Dockerfile:
   - nano Dockerfile

```
FROM nginx
RUN rm -rf /usr/share/nginx/html/index.html
ADD . /usr/share/nginx/html/
RUN sed -i "s/%%hostname%%/$(hostname)/" /usr/share/nginx/html/index.html

```
 - build image
   - docker build -f Dockerfile -t my_site_nginx .
  
 ![зображення](https://user-images.githubusercontent.com/97990456/214718722-4cbeecdd-64a5-444e-ba9e-9bf027017682.png)
 
 **Run the docker container at port 8080**
 
   - docker run -p 8080:80 -d --name my_prod_site my_site_nginx
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214721242-68823077-13c3-4fff-ba50-3e7a24125683.png)


**Open page in Web Browser**

![зображення](https://user-images.githubusercontent.com/97990456/214719950-5ad68c6a-e29c-4e36-8242-9c6530d13a27.png)

 
**Task 2**
  
  **Prepare private and public network**
   - docker network create --internal private-network (Default driver "bridge")
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214736601-72e2a8d9-cac8-4320-ba48-1d2d18b7a9b8.png)

   - docker network create public-network (Default driver "bridge")
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214739580-bc28a51c-c645-4086-b897-668cc01860f9.png)
 
 **Prepare one dockerfile based on ubuntu with the ping command**

