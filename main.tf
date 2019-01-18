
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
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





resource "aws_instance" "debian_instance" {
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

instances                   = ["${aws_instance.debian_instance.id}"]
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
    
    
    
    
    
    
    
    
    
    
    
