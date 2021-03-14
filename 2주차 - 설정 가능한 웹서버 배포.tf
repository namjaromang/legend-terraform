/*
variable "list-exam" {
  description = "An example of a list in Terraform"
  type = list
  default = [1, 2, 3]
}

variable "map_example" {
  description = "An example of a map in Terraform"
  type = map
  default = {
    key1 = "value01"
    key2 = "value02"
    key3 = "vaule03"
  }
}

variable "server_port" {
  description = "The port the server will user for HTTP requests"
  default = 8080
}

resource "aws_security_group" "ec2-web-port" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ec2-create-web-port" {
  ami = "ami-00f1068284b9eca92"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2-web-port.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    Name = "terraform-ec2-web"
  }
}

output "ec2-public-IP" {
  value = aws_instance.ec2-create-web-port.public_ip
}*/
