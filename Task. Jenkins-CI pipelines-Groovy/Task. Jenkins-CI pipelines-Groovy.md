**Project "My Site"**

The  project include:
1) [Optional] Script for automated Jenkins setup (with user, plugins). Name install_jenkins.sh
2) Multibranch pipeline connect  with the Gitlab/Github project repository with the Jenkinsfile
3) Jenkinsfile has several stages: Build, Test, Deploy, Notification (Telegram bot)
4) [Optional] Used branch conditions, vars


**1) Bash script for automatic configuration of Jenkins (with user, plugins):**

install_jenkins.sh

```
#!/bin/bash

#Install java
sudo apt update
sudo apt install -y openjdk-11-jre 

#Install jenkins
sudo apt install -y curl
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install -y jenkins

sudo systemctl start jenkins
sudo systemctl enable jenkins

# disable the initial setup of  jenkins
sudo chmod 666 /etc/default/jenkins
sudo echo 'JAVA_ARGS="-Djenkins.install.runSetupWizard=false"' >> /etc/default/jenkins
sudo chmod 644 /etc/default/jenkins

# add user 'admin' with password 'admin'
sudo -u jenkins mkdir /var/lib/jenkins/init.groovy.d
sudo -u jenkins touch /var/lib/jenkins/init.groovy.d/basic-security.groovy
sudo chmod 666 /var/lib/jenkins/init.groovy.d/basic-security.groovy

sudo echo "
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','admin')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

instance.save() " > /var/lib/jenkins/init.groovy.d/basic-security.groovy

sudo chmod 665 /var/lib/jenkins/init.groovy.d/basic-security.groovy

sudo systemctl restart jenkins

# Install jenkins-cli

curl -O http://localhost:8080/jnlpJars/jenkins-cli.jar

# Install plugins


if [ -f "jenkins-cli.jar" ]; then

    declare  -a PluginList=(
        "blueocean"
        "Locale"
        "Publish-Over-SSH"
        "Multibranch-Scan-Webhook-Trigger"
    )

    for plugin in ${PluginList[@]}; do
        java -jar jenkins-cli.jar -auth admin:admin -s http://localhost:8080/ install-plugin $plugin

    done
fi

sudo systemctl restart jenkins

```

**2) Multibranch  pipeline connect  with the Gitlab/Github project repository with the Jenkinsfile:**

project repository contain two branches:
1) main branch
![зображення](https://user-images.githubusercontent.com/97990456/213935813-18e6e682-2eae-4a66-a559-591f00a3a1f7.png)
2) dev branch
![зображення](https://user-images.githubusercontent.com/97990456/213930061-ddf1abb8-bc26-43ab-819a-e5f55ef9eb8c.png)

**Steps:**

For Jenkins add сredentials:

- geterate token  for Jenkins on github

  (Settings-> Developer settings -> Personal access tokens (classic) -> Generate new token ->  Generate new token(Classic) 
  
 ![зображення](https://user-images.githubusercontent.com/97990456/213931180-2b674ce7-a81b-4c3c-b7a8-1ddb0e6dfa4a.png)
 
   `generated token`
 ![зображення](https://user-images.githubusercontent.com/97990456/213931568-f2977fbd-7001-4964-a96e-1c869f36840e.png)
 
- add credentials to Jenkins
 ![зображення](https://user-images.githubusercontent.com/97990456/213941528-971eff02-de39-43f7-af5c-7224e46f7357.png)

 
**Create Mutibranch pupline:**

![зображення](https://user-images.githubusercontent.com/97990456/213930581-79e11ca4-7e97-48da-9249-61781f30b71c.png)
![зображення](https://user-images.githubusercontent.com/97990456/213930609-9b988c14-83ad-41fe-833c-be750f71b58b.png)
![зображення](https://user-images.githubusercontent.com/97990456/213930644-bcf63757-e85e-4628-bd58-2f08078021a8.png)

**After validating the credentials, Jenkins displays the branches:**

![зображення](https://user-images.githubusercontent.com/97990456/213942433-e135a828-ea44-4c95-8747-ad6a7076b9c3.png)


**Add a Webhook Multibranch Pipeline in Two Steps:**

(this options  need  for  automatic  run jobs after  push to github)

 - On Jenkins
    - enter Trigger token
      ![зображення](https://user-images.githubusercontent.com/97990456/213931699-9dc15658-5be8-4c39-814a-402e2e4ea610.png)



 - On Github
   - Go Settings -> Webhooks -> add webhook
   - enter `<Jenkins_url>`/multibranch-webhook-trigger/invoke?token=`token`

   ![зображення](https://user-images.githubusercontent.com/97990456/213931955-22367c35-507d-442e-aa54-f7452d8d31a1.png)

  
**3) Jenkinsfile has several stages: Build, Test, Deploy, Notification (Telegram bot)**
  
  
 ```
 pipeline {
    agent any
    
    stages {
        stage('1-Build-Dev') {
            when {
                anyOf {
                    branch "dev"
                }
            }
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/dev']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Git_hub_ssh', url: 'git@github.com:ZEN10111/MY_Site.git']]]) 
            }
        }
        stage('2-Test-Dev') {
            when {
                anyOf {
                    branch "dev"
                }
            }
            steps {
            sh '''
            echo "------------------pre test Starter-------------------------"
            ls -la
            cat Site/index.html
            echo "------------------pre test Finished------------------------" 
              '''
            sh '''
            echo "------------------Test Starter-------------------------"
            result=`grep "Bukovel" Site/index.html | wc -l`
            echo $result 
            if [ "$result" -ge "1" ]; 
            then 
                echo "Test Pased"
            else
                echo "Failed Pased"
            exit 1
            fi
            echo "------------------Test Finished-------------------------" 
             '''
            }
        }
        stage('3-Deploy-Dev') {
            when {
                anyOf {
                    branch "dev"
                }
            }
            steps([$class: 'BapSshPromotionPublisherPlugin']) {
                sshPublisher(
                    continueOnError: false, failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                           configName: "Dev_server",
                           verbose: true,
                           transfers: [
                                sshTransfer(sourceFiles: "Site/*",),
                                sshTransfer(execCommand: 'sed -i "s/%%hostname%%/$(hostname)/" /var/www/html/Site/index.html'),
                                sshTransfer(execCommand: "sudo systemctl restart nginx")
                                
                            ]
                        )
                    ]
                )
           }
        }

          stage('1-Build-Prod') {
             when {
                anyOf {
                    branch "main"
                }
            }
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Git_hub_ssh', url: 'git@github.com:ZEN10111/MY_Site.git']]]) 
            }
        }
        stage('2-Test-Prod') {
             when {
                anyOf {
                    branch "main"
                }
            }
            steps {
            sh '''
            echo "------------------pre test Starter-------------------------"
            ls -la
            cat Site/index.html
            echo "------------------pre test Finished------------------------" 
              '''
            sh '''
            echo "------------------Test Starter-------------------------"
            result=`grep "Bukovel" Site/index.html | wc -l`
            echo $result 
            if [ "$result" -ge "1" ]; 
            then 
                echo "Test Pased"
            else
                echo "Failed Pased"
            exit 1
            fi
            echo "------------------Test Finished-------------------------" 
             '''
            }
        }
        stage('3-Deploy-Prod') {
             when {
                anyOf {
                    branch "main"
                }
            }
            steps([$class: 'BapSshPromotionPublisherPlugin']) {
                sshPublisher(
                    continueOnError: false, failOnError: true,
                    publishers: [
                        sshPublisherDesc(
                           configName: "Prod_server",
                           verbose: true,
                           transfers: [
                                sshTransfer(sourceFiles: "Site/*",),
                                sshTransfer(execCommand: 'sed -i "s/%%hostname%%/$(hostname)/" /var/www/html/Site/index.html'),
                                sshTransfer(execCommand: "sudo systemctl restart nginx")
                                
                            ]
                        )
                    ]
                )
           }
        }   
        stage('4-Notification') {
            steps {
                telegramSend "Branch - ${BRANCH_NAME}. Deploy is finished"
            }
        }

    }
}
```

 - Stage "Build" - use github  to get Site files
 - Stage "Test"-  serach word Bukovel on index.html and  pass win fins 1  or more сoincidence 
 - Deploy  - Deliver site  files  to  servers via ssh
 - Notification (Telegram bot) - how  to use - https://github.com/jenkinsci/telegram-notifications-plugin/blob/master/README.md
 
 
 For  Deliver site  files  to  servers via ssh need :
 - add credentials (private key)
![зображення](https://user-images.githubusercontent.com/97990456/213933669-8e2208d3-4994-418a-b654-a67892a00708.png)

- add servers 
- add Remote Directory

![зображення](https://user-images.githubusercontent.com/97990456/213933688-ac9005c5-c997-464d-88ae-f9d19e33c295.png)
![зображення](https://user-images.githubusercontent.com/97990456/213933715-6083fb4f-01ce-4d38-98d1-2a60f9841ae7.png)

 - for Ubuntu 22.04 if receive an error "jenkins.plugins.publish_over.BapPublisherException: Failed to connect and initialize SSH connection Message [Auth fail]"
   must be done on remote servers  :
   - add two line in /etc/ssh/sshd_config
   ```
   PubkeyAuthentication yes
   PubkeyAcceptedKeyTypes +ssh-rsa
   ```
   ```
   sudo service sshd restart
   
   ```

For use Telegram bot need:

 - generate token for Telegram bot on git hub on same way as for Jenkin
 - setup on Jenkins configuration:
  ![зображення](https://user-images.githubusercontent.com/97990456/213937785-aac81e39-bfca-441e-91b3-4b5a392daa0c.png)



**4) [Optional] Used branch conditions, vars**

 - Jenkinsfile has  Stages:
   - for only main branch
    ![зображення](https://user-images.githubusercontent.com/97990456/213934326-cee6a311-da2f-4670-b918-459b8fbe362f.png)
   -  only for dev branch
    ![зображення](https://user-images.githubusercontent.com/97990456/213934340-ce6e53b6-d7f7-4772-89da-a3390e192d33.png)

- Jenkinsfile has several variables:
 - $result - result of serch condition for  test
 - ${BRANCH_NAME} - name  of brunch on telegram bot message


**Infrastructure:**

3 instances on AWS:

![зображення](https://user-images.githubusercontent.com/97990456/213934867-1e1f42a8-ab5a-4d80-bf4d-a25d406262e4.png)

 - Jenkisn  server with our project
 
 ![зображення](https://user-images.githubusercontent.com/97990456/213934981-06502b96-1f08-434b-8919-5dcf704b5e2f.png)
 
 - Dev server
 
 ![зображення](https://user-images.githubusercontent.com/97990456/213935159-c2fefd9e-277b-468c-b29a-d3f4631980f7.png)

 - Prod server 

 ![зображення](https://user-images.githubusercontent.com/97990456/213935188-cb99f2e2-b783-45ef-bc5e-8e60981946df.png)


**Telegram notifications:**

![зображення](https://user-images.githubusercontent.com/97990456/213935257-c0487021-f992-40c4-9fa8-871f677d3d2a.png)


