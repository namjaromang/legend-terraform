resource "aws_instance" "test-mj" {
  ami           =  "ami-0e17ad9abf7e5c818"
  instance_type = "t3.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "test-mj"
  }
}

resource "aws_launch_configuration" "example" {
    image_id        = "ami-0e17ad9abf7e5c818"
    instance_type   = "t3.micro"
    security_groups = ["${aws_security_group.instance.id}"]

    user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  }

resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.example.id}"
    availability_zones = ["ap-northeast-2c"]

    load_balancers = ["{aws_elb.example.name"]
    health_check_type = "ELB"

    max_size = 2
    min_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "example" {
    name = "terraform-asg-example"
    availability_zones = ["ap-northeast-2a"]
    security_groups = ["${aws_security_group.elb.id}"]

    listener {
      instance_port = "${var.server_port}"
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "HTTP"
    }

    health_check {
      healthy_threshold = 2
      interval = 30
      target = "HTTP:${var.server_port}/"
      timeout = 3
      unhealthy_threshold = 2
    }
}

resource "aws_security_group" "elb" {
    name = "terraform-example-elb"

    ingress {
      from_port = 80
      protocol = "tcp"
      to_port = 80
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      protocol = "-1"
      to_port = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
}



