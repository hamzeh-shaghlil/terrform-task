#!/bin/bash
#update packages
sudo apt update -y
#Install packages to allow apt to use a repository over HTTPS:
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg2 -y
#Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
#add Docker repository to the system
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" -y
#Update the apt package index.
sudo apt update -y
#Install the latest version of Docker CE 
sudo apt install docker-ce -y
#clone repository data from My Github account into the server (DockerFile and index.html)
sudo git clone https://github.com/hamzehsh/terrform-task.git /home/admin/repo
#Build docker-image using  the docker-file that we cloned from the GitHub repository
sudo docker build -t webserver-image:v1 /home/admin/repo/
#Run Docker container  using webserver-image:v1 image on port 80
sudo docker run -d -p 80:80 webserver-image:v1
