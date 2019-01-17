#!/bin/bash
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg2 -y
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" -y
sudo apt update -y
sudo apt install docker-ce -y
sudo git clone https://github.com/hamzehsh/terrform-task.git /home/admin/repo
sudo docker build -t webserver-image:v1 /home/admin/repo/
sudo docker run -d -p 80:80 webserver-image:v1
