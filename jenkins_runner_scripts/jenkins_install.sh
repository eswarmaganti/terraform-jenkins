#! /bin/bash

set -x 

yes | sudo apt-get update
yes | sudo apt install fontconfig openjdk-17-jre
echo "*** Info: Installation of jenkins will start in 30 seconds ... ***"
sleep 30

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
yes | sudo apt-get update
yes | sudo apt-get install jenkins
echo "*** Success: Jenkins installation is completed ***"

echo "*** Info: Installation of terraform will start in 30 seconds ... ***"
sleep 30

wget https://releases.hashicorp.com/terraform/1.7.5/terraform_1.7.5_linux_amd64.zip
yes | sudo apt-get install unzip
unzip "terraform*.zip"
sudo mv terraform /usr/local/bin