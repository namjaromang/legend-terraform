/*
resource "aws_security_group" "sg-web" {
  name = "terraform-exam-ec2"
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-create-web" {
  ami = "ami-00f1068284b9eca92"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg-web.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "terraform-ec2-web"
  }
}*/
