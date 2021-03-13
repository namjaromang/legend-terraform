resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "key-an2-nws-terrafom"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "ec2_instance" {
  ami = "ami-0e17ad9abf7e5c818"
  instance_type = "t2.micro"
  availability_zone = "ap-nothrast-2a"
  key_name = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
  user_data = <<-EOF
            #!/bin/bash
            sudo su
            yum install -y httpd
            systemctl start httpd.service
            systemctl enable httpd.service
            echo "Hello World" > /var/www/html/index.html
            EOF
  tags = {
    Name = "ec2-an2-nws-tarraform-01a"
  }
}

resource "aws_elb" "ec2_elb" {
  name                = "xelb-an2-nws-terrafom"
  instances           = [aws_instance.ec2_instance.id]
  security_groups     = [aws_security_group.elb_sg.id]
  availability_zones  = ["ap-nothrast-2a", "ap-nothrast-2c"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    target              = "TCP:80"
    interval            = 10
  }

  tags = {
    Name = "xelb-an2-nws-terrafom"
  }
}

resource "aws_security_group" "ec2_sg" {
  name = "sg_an2_nws_terraform"
  description = "sg_an2_nws_terraform"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "elb_sg" {
  name = "sg_an2_nws_terraform_elb"
  description = "sg_an2_nws_terraform_elb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
