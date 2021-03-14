resource "aws_key_pair" "ymj-test" {
  key_name   = "ymj-test"
  public_key = file("<./ymj-test.pub>")
}

resource "aws_instance" "ymj-test" {
  ami                    = "ami-0e17ad9abf7e5c818"
  instance_type          = "t2.micro"
  key_name               = "ymj-test"
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
    user_data = <<-EOF
                #!/bin/bash
                sudo su
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hello, world" > /var/www/html/index.html
                EOF
    tags      = {
    Name      =  "terraform-test"
  }
}

resource  "aws_security_group" "instance" {
  name = "terraform-test-instance"
  ingress {
    from_port               = 80
    protocol                = "http"
    to_port                 = 80
    }
}

resource "aws_alb" "test_elb" {
    name                    = "terraform-asg-test"
    availbility_zones       = [
      "${data.aws.availability_zones.all.names}"
  ]

  listener {
    lb_port                 = 80
    lb_protocol             = "http"
    instance_port           = ${var.server_port}"
    instance_protocol       = "http"
    }

  health_check {
        healthy_threshold   = 2
        unhealty_threshold  = 2
        timeout             = 3
        interval            = 30
        target              =
}
}


