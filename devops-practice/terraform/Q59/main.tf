provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_security_group" "web" {
  name = "q59-web"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  count = 3
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web.name]
}
