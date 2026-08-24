provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_instance" "backend" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

resource "aws_instance" "frontend" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
