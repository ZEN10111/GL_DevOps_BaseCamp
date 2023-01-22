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
    )

    for plugin in ${PluginList[@]}; do
        java -jar jenkins-cli.jar -auth admin:admin -s http://localhost:8080/ install-plugin $plugin

    done
fi

sudo systemctl restart jenkins

