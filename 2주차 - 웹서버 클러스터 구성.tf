data "aws_availability_zones" "all" {}

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  default = 8080
}

resource "aws_launch_configuration" "asg-launch" {
  image_id = "ami-00f1068284b9eca92"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.asg-sg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg-group" {
  launch_configuration = aws_launch_configuration.asg-launch.id
  availability_zones = data.aws_availability_zones.all.names
  load_balancers = [aws_elb.asg-elb.name]
  health_check_type = "ELB"

  min_size = 2
  max_size = 3

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-asg"
  }
}

output "elb_dns_name" {
  value = aws_elb.asg-elb.dns_name
}

resource "aws_security_group" "asg-sg" {
  name = "terraform-exam-sg"

  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "asg-elb" {
  name = "terraform-asg-elb"
  availability_zones = data.aws_availability_zones.all.names
  security_groups = [aws_security_group.asg-elb-sg.id]
  listener {
    instance_port = var.server_port
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }

}

resource "aws_security_group" "asg-elb-sg" {
  name = "terraform-exam-elb-sg"

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