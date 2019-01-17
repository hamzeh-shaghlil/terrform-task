provider "aws" {
  access_key = ""
  secret_key = ""
  region     = ""
}



data "aws_availability_zones" "available" {}

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




resource "aws_instance" "my_first_instance" {
    ami           = "${data.aws_ami.latest-debian.id}"
    instance_type = "t2.micro"
    key_name    = "debian"
    user_data = "${file("userdata.sh")}"
    tags { Name ="debian-terraform"          
    
    }
    
    }
    
    
    
    
    
    
    resource "aws_elb" "MyELB" {
  name               = "My-ELB"
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
