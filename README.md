# Exercise 2
**This project uses Terrraform script to provision the below resources:**

- An EC2 instance of type t2.micro based on a Debian Stretch Image.
- A Loadbalancer forwarding incoming requests to the EC2 instance.
- The EC2 instance runs an Nginx webserver serving one HTML file (index.html cloned from a Github repo). 
- The Nginx is a Docker container started on the EC2 instance (DockerFile cloned from a GitHub repo).




### Prerequisites

- Terraform latest version proper with your operating system and architecture.
- AWS Account with proper AWS Credentials 



### Installing

1. Clone or Download this repo to your local machine using "https://github.com/hamzehsh/terrform-task.git"
2. Run from your terminal ```terraform init ``` command to Initialize a Terraform working directory inside .
3. Run ```terraform apply ``` command to Builds the infrastructure
4. you will be ask to Enter your AWS Credentials and The Region that you want to work in it.
5. approve for terraform to perform the described actions
6. once the creating process finish you will have The Loadblancer endpoint as output which you can use it to access the html page.








## main.tf

### This Terraform script is used to provision AWS infrastructure based on the region variable 


>   Configure the AWS Provider (AWS credentials) as vaiables from variables.tf 

```
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

```

>   Declare the data source (query to get the AZ in the region)
```
data "aws_availability_zones" "available" {}
```
>  Query the AWS API for the latest Depian AMI version
```
data "aws_ami" "latest-debian" {
most_recent = true
owners = ["379101102735"] # Canonical

  filter {
      name   = "name"
      values = ["debian-stretch-hvm-x86_64-gp2-2018-11-10-63975"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}
```

>  Create a Security Group for EC2 (webserver).

```
    resource "aws_security_group" "debian-SG" {
  name        = "debian-SG"
  description = "webserver-SG"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  

  tags = {
    Name = "debian-SG"
  }
}


```




>  Create a Security Group for ELB (Loadblancer).
```
resource "aws_security_group" "ELB-SG" {
  name        = "ELB-SG"
  description = "LoadBlancer-SG"
  

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  
  tags = {
    Name = "ELB-SG"
  }
}

```

>  Create EC2 (Webserver) Debian using the latest AMI image query with The userdata path to run shell scipt once once launching  The EC2 and attach the security group that we have created in the previous resource.
```
resource "aws_instance" "my_first_instance" {
    ami           = "${data.aws_ami.latest-debian.id}"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.debian-SG.id}"]
    user_data = "${file("userdata.sh")}"
    tags { Name ="debian-terraform"          
    
    }
    
    }
  ```  
    
    
    
>  Create Classic LoadBlancer and attach the EC2 Instance (webserver)
  ```  
    
    resource "aws_elb" "MyELB" {
  name               = "My-ELB"
  security_groups = ["${aws_security_group.ELB-SG.id}"]
  availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]

 

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

 

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  

instances                   = ["${aws_instance.my_first_instance.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400




  tags = {
    Name = "MY-ELB"
  }
}
    
  ```      
    
    
    
>   Declare output to show us the DNS ENDPoint address of the Loadbnalncer that we create so we can request the html page through it.
    
output "LoadBalancer DNS" {
  value = "${aws_elb.MyELB.dns_name}"
}
    
  
    
    
    
    
## userdata.sh

> This Userdata file include the shell script that used to bootstrap the EC2 instance, including the following steps:**
  ```  
1. Update the apt package index.
2. Install packages to allow apt to use a repository over HTTPS:
3. Add Docker’s official GPG key:
4. Add Docker repository to the system
5. Update the apt package index.
6. Install the latest version of Docker CE 
7. Clone repository data from My Github account into the server (DockerFile and index.html)
8. Build docker-image using  the docker-file that we cloned from the GitHub repository
9. Run Docker container  using webserver-image:v1 image on port 80
  ```  
  ``` 
    #!/bin/bash
#Update the apt package index.
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
    
    
``` 




## variables.tf
> Defines AWS Credentials Variables
``` 
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
``` 




## Authors
* **Hamzeh Shaghlil** - [Linkedin](https://www.linkedin.com/in/hamzeh-shaghlil
)





