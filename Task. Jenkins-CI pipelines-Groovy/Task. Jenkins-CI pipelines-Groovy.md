The  project include
1) [Optional] Script for automated Jenkins setup (with user, plugins). Name install_jenkins.sh
2) Multibranch pipeline connect  with the Gitlab/Github project repository with the Jenkinsfile
3) Jenkinsfile has several stages: build, tests, notification (telegram bot, etc.)
4) [Optional] Use branch conditions, vars, etc


**Script for automatic configuration of Jenkins (with user, plugins):**
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
        "Publish Over SSH"
        "Multibranch Scan Webhook Trigger"
    )

    for plugin in ${PluginList[@]}; do
        java -jar jenkins-cli.jar -auth admin:admin -s http://localhost:8080/ install-plugin $plugin

    done
fi

sudo systemctl restart jenkins
```
**Multibranch  pipeline connect  with the Gitlab/Github project repository with the Jenkinsfile:**
contain two branches - main and dev
1) main branch
2) dev branch
![зображення](https://user-images.githubusercontent.com/97990456/213929672-81e3cb8f-214e-4583-af67-e2e594003742.png)
![зображення](https://user-images.githubusercontent.com/97990456/213930061-ddf1abb8-bc26-43ab-819a-e5f55ef9eb8c.png)

In Jenkins add Credentials:
- you must first  create a  token  for  Jenkins on  github
  (Settings-> Developer settings -> Personal access tokens (classic) -> Generate new token ->  Generate new token(Classic) 
  
 ![зображення](https://user-images.githubusercontent.com/97990456/213931180-2b674ce7-a81b-4c3c-b7a8-1ddb0e6dfa4a.png)
 ![зображення](https://user-images.githubusercontent.com/97990456/213931568-f2977fbd-7001-4964-a96e-1c869f36840e.png)

 - Add token with github username to Jenkins

![зображення](https://user-images.githubusercontent.com/97990456/213930322-d3f768ac-3592-4009-aa42-1a50096d0222.png)


Create Mutibranch pupline

![зображення](https://user-images.githubusercontent.com/97990456/213930581-79e11ca4-7e97-48da-9249-61781f30b71c.png)
![зображення](https://user-images.githubusercontent.com/97990456/213930609-9b988c14-83ad-41fe-833c-be750f71b58b.png)
![зображення](https://user-images.githubusercontent.com/97990456/213930644-bcf63757-e85e-4628-bd58-2f08078021a8.png)

After validating credentials, jenkins displays branches:

![зображення](https://user-images.githubusercontent.com/97990456/213930729-9bd11e7e-1e2d-42f3-af80-b7001b654123.png)

Add a Webhook Multibranch Pipeline in Two Steps

 - On jenkins
    - enter Trigger token
      ![зображення](https://user-images.githubusercontent.com/97990456/213931699-9dc15658-5be8-4c39-814a-402e2e4ea610.png)



 - On Github
   - Go Settings -> Webhooks -> add webhook
   - enter <Jenkins url>/multibranch-webhook-trigger/invoke?token=<token>

![зображення](https://user-images.githubusercontent.com/97990456/213931955-22367c35-507d-442e-aa54-f7452d8d31a1.png)

  







