# Exercise 2
**This project uses Terrraform script to provision the below resources:**

- An EC2 instance of type t2.micro based on a Debian Stretch Image.
- A Loadbalancer forwarding incoming requests to the EC2 instance.
- The EC2 instance runs an Nginx webserver serving one HTML file (index.html cloned from a Github repo). 
- The Nginx is a Docker container started on the EC2 instance (DockerFile cloned from a GitHub repo).

## main.tf

This Terraform script is used to provision AWS infrastructure based on the region variable.

Inputs:

## userdata.sh

**This shell script is used to bootstrap the EC2 instance, including the following steps:**

1. Update the apt package index.
2. Install packages to allow apt to use a repository over HTTPS:
3. Add Docker’s official GPG key:
4. Add Docker repository to the system
5. Update the apt package index.
6. Install the latest version of Docker CE 
7. Clone repository data from My Github account into the server (DockerFile and index.html)
8. Build docker-image using  the docker-file that we cloned from the GitHub repository
9. Run Docker container  using webserver-image:v1 image on port 80


## main.tf

###  Configure the AWS Provider (AWS credentials) as vaiables from variables.tf 

```
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

```
```
###  Declare the data source (query to get the AZ in the region)
data "aws_availability_zones" "available" {}
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

















resource "aws_instance" "my_first_instance" {
    ami           = "${data.aws_ami.latest-debian.id}"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.debian-SG.id}"]
    user_data = "${file("userdata.sh")}"
    tags { Name ="debian-terraform"          
    
    }
    
    }
    
    
    
    

    
    
    
    
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
    
    
    
    
    
    
    
output "LoadBalancer DNS" {
  value = "${aws_elb.MyELB.dns_name}"
}
    
```    
    
    
    
    
    
    
    
    
    

















```python
import foobar

foobar.pluralize('word') # returns 'words'
foobar.pluralize('goose') # returns 'geese'
foobar.singularize('phenomena') # returns 'phenomenon'
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
