**Task 1**

**1. Install docker:**

 ``` nano  install_dosker.sh```

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

 ``` chmod +x install_dosker.sh ```
 
 ``` ./install_dosker.sh ```


 - result :
 
  ![зображення](https://user-images.githubusercontent.com/97990456/214573119-d4447ac1-5cfc-43f6-928d-246aff1c94ec.png)
  ![зображення](https://user-images.githubusercontent.com/97990456/214573244-115eeb5a-5e32-437f-af19-39651538371f.png)
  
 - after re-login curent user:
 
  ![зображення](https://user-images.githubusercontent.com/97990456/214573566-e0404e6e-3c4a-49e9-b528-f6af0d34e812.png)

**2-3. Prepare a dockerfile based on Apache or Nginx image and 
Added your own index.html page with my name and surname to the docker image**

 - Get own  site files from github(site contains my name) :

   ``` git clone https://github.com/ZEN10111/site.git ```

   ![зображення](https://user-images.githubusercontent.com/97990456/214716128-efdc2d10-6bcc-4b59-a6d1-cfcdc017464c.png)


  - enter into site directory and watch files :
  
   ```
    cd site
    ls -la 
   ```
  
   ![зображення](https://user-images.githubusercontent.com/97990456/214716975-4fb3e1f9-5916-4b24-9a66-2f36fd1b2449.png)
 
 - make .dockerignore file ( to ignore files that are not needed in the image):
  
   ``` echo '.git' > .dockerignore ```
 
 - make Dockerfile:
 
   ```nano Dockerfile```

```
FROM nginx
RUN rm -rf /usr/share/nginx/html/index.html
ADD . /usr/share/nginx/html/
RUN sed -i "s/%%hostname%%/$(hostname)/" /usr/share/nginx/html/index.html

```
 - build image
 
   ``` docker build -f Dockerfile -t my_site_nginx . ```
  
 ![зображення](https://user-images.githubusercontent.com/97990456/214718722-4cbeecdd-64a5-444e-ba9e-9bf027017682.png)
 
 **4. Run the docker container at port 8080**
 
  ``` docker run -p 8080:80 -d --name my_prod_site my_site_nginx ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214721242-68823077-13c3-4fff-ba50-3e7a24125683.png)


**5. Open page in Web Browser**

![зображення](https://user-images.githubusercontent.com/97990456/214719950-5ad68c6a-e29c-4e36-8242-9c6530d13a27.png)

 
**Task 2**
  
  **1. Prepare private and public network**
  
   ``` docker network create --internal private-network ``` (Default driver "bridge")
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214736601-72e2a8d9-cac8-4320-ba48-1d2d18b7a9b8.png)

   ``` docker network create public-network ``` (Default driver "bridge")
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214739580-bc28a51c-c645-4086-b897-668cc01860f9.png)
 
 **2. Prepare one dockerfile based on ubuntu with the ping command**
 
 - make Dockerfile:
   ``` nano Dockerfile ```

```
FROM ubuntu
RUN apt-get update && apt-get install -y iputils-ping
ENV HOST = 127.0.0.1
CMD ping ${HOST}
```

 ``` docker build -f Dockerfile -t ping_host . ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214753683-eda85854-604f-49be-bd67-7e04affe15cb.png)
 
**3. One container must have access to the private and public networks 
  the second container must be in the private network**
  
 ``` docker run -d --network public-network -e 'HOST=www.globallogic.com' --name public-container ping_host ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214757236-017e3ff4-5d98-47e1-9412-710014be0e7a.png)
 
   ``` docker network connect private-network public-container ```
 
   ``` docker inspect public-network ```
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214757660-c8e3de39-963b-4815-8248-4e697fc28557.png)
   
   ``` docker inspect private-network ```
   
   ![зображення](https://user-images.githubusercontent.com/97990456/214757881-a200817b-81a8-4be6-9e09-ed51c0ff784a.png)
   
 ``` docker run -d --network private-network -e 'HOST=172.19.0.2' --name private-container ping_host ```
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214758239-55ee2b06-c8f8-4603-bba1-04e919d006c2.png)
 
 ``` docker inspect public-network ``` (contains only one container)
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214758663-a105d3e2-e50f-49c7-9a8d-bfa5fda8fe0f.png)
 
 ``` docker inspect private-network ``` (contains two container)
 
 ![зображення](https://user-images.githubusercontent.com/97990456/214758902-408a5e00-0ff6-439d-8e54-64efb1657964.png)

 **4. A ) Run a container that has access to the public network and ping some resources (
example: google.com )**

  in our container we will ping www.globallogic.com :)
 
  we  can do it in two ways:
 
   - attach to  container :
  
     ``` docker attach public-container ```
   
     ![зображення](https://user-images.githubusercontent.com/97990456/214760120-8720f09d-7156-46ff-a0c8-fca260fb0125.png)
    
     - to detach in another host shell  do:
         ``` 
         ps -ef | grep attach  
         kill -9 <PID>
         ````
  - or run ping commad:  
 
    ``` docker exec -it public-container ping www.globallogic.com ```
 
    ![зображення](https://user-images.githubusercontent.com/97990456/214760914-32c2766f-7693-4eea-924d-90c24f03f8e9.png)

    - For interrupt  ```press ctrl+C```
 
 **4. B ) The second container ping the first container via a private network**
 
    - we also can do it in two ways:
 
      - attach to  container :
 
        ``` docker attach private-container ```
 
     ![зображення](https://user-images.githubusercontent.com/97990456/214763940-19b86203-691d-4ae4-9c9d-0b6de5904e4c.png)
    
      - run ping commad : 
 
        ``` docker exec -it private-container ping 172.19.0.2 ```
 
      ![зображення](https://user-images.githubusercontent.com/97990456/214764341-841017c4-49a3-4f89-801f-02ec71c33c25.png)
 
       - but if we  try to ping external address  -  ping not  pass  because in this  container we  have only private network
       
       ![зображення](https://user-images.githubusercontent.com/97990456/214764637-722a9b07-bb55-465a-9f19-147e7510e16b.png)

 
