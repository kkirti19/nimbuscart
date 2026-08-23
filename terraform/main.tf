terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ============================================================
# DATA SOURCES
# ============================================================

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ============================================================
# WEB VPC
# ============================================================

resource "aws_vpc" "web" {
  cidr_block           = var.web_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-web-vpc"
    Tier = "web"
  }
}

resource "aws_internet_gateway" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name = "${var.project_name}-web-igw"
  }
}

resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.web.id
  cidr_block              = var.web_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-web-subnet"
    Tier = "web"
  }
}

resource "aws_route_table" "web" {
  vpc_id = aws_vpc.web.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web.id
  }

  tags = {
    Name = "${var.project_name}-web-rt"
  }
}

resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.web.id
}

# ============================================================
# DATA VPC
# ============================================================

resource "aws_vpc" "data" {
  cidr_block           = var.data_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-data-vpc"
    Tier = "data"
  }
}

# ============================================================
# APP SUBNET
# ============================================================

resource "aws_subnet" "app" {
  vpc_id            = aws_vpc.data.id
  cidr_block        = var.app_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-app-subnet"
    Tier = "app"
  }
}

# ============================================================
# DB SUBNETS
# ============================================================

resource "aws_subnet" "db_a" {
  vpc_id            = aws_vpc.data.id
  cidr_block        = var.db_subnet_a_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.project_name}-db-subnet-a"
    Tier = "db"
  }
}

resource "aws_subnet" "db_b" {
  vpc_id            = aws_vpc.data.id
  cidr_block        = var.db_subnet_b_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.project_name}-db-subnet-b"
    Tier = "db"
  }
}

# ============================================================
# APP ROUTING
# No NAT Gateway - avoids NAT charges
# ============================================================

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.data.id

  tags = {
    Name = "${var.project_name}-app-rt"
  }
}

resource "aws_route_table_association" "app" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.app.id
}

# ============================================================
# DB ROUTING
# ============================================================

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.data.id

  tags = {
    Name = "${var.project_name}-db-rt"
  }
}

resource "aws_route_table_association" "db_a" {
  subnet_id      = aws_subnet.db_a.id
  route_table_id = aws_route_table.db.id
}

resource "aws_route_table_association" "db_b" {
  subnet_id      = aws_subnet.db_b.id
  route_table_id = aws_route_table.db.id
}

# ============================================================
# VPC PEERING
# ============================================================

resource "aws_vpc_peering_connection" "web_data" {
  vpc_id      = aws_vpc.web.id
  peer_vpc_id = aws_vpc.data.id
  auto_accept = true

  tags = {
    Name = "${var.project_name}-web-data-peering"
  }
}

# WEB -> DATA
resource "aws_route" "web_to_data" {
  route_table_id            = aws_route_table.web.id
  destination_cidr_block    = var.data_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.web_data.id
}

# APP -> WEB
resource "aws_route" "app_to_web" {
  route_table_id            = aws_route_table.app.id
  destination_cidr_block    = var.web_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.web_data.id
}

# DB -> WEB
resource "aws_route" "db_to_web" {
  route_table_id            = aws_route_table.db.id
  destination_cidr_block    = var.web_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.web_data.id
}

# ============================================================
# WEB SECURITY GROUP
# ============================================================

resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "NimbusCart web tier"
  vpc_id      = aws_vpc.web.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

# ============================================================
# APP SECURITY GROUP
# ============================================================

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "NimbusCart application tier"
  vpc_id      = aws_vpc.data.id

  ingress {
    description = "API from web VPC"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.web_vpc_cidr]
  }

  ingress {
    description = "SSH from web VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.web_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# ============================================================
# DB SECURITY GROUP
# ============================================================

resource "aws_security_group" "db" {
  name        = "${var.project_name}-db-sg"
  description = "NimbusCart database tier"
  vpc_id      = aws_vpc.data.id

  ingress {
    description = "PostgreSQL from app subnet"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.app_subnet_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

# ============================================================
# WEB EC2
# ============================================================

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.web.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-web"
    Tier = "web"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/kirti/.ssh/terraform-key.pem")
    host        = self.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "../app/frontend/index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3",
      "sudo mkdir -p /var/www/nimbuscart",
      "sudo cp /tmp/index.html /var/www/nimbuscart/index.html",
      "sudo systemd-run --unit=nimbuscart-frontend --no-block python3 -m http.server 80 --directory /var/www/nimbuscart"
    ]
  }
}

# ============================================================
# APP EC2
# ============================================================

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.app.id
  vpc_security_group_ids = [aws_security_group.app.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.project_name}-app"
    Tier = "app"
  }
}

# ============================================================
# RDS SUBNET GROUP
# ============================================================

resource "aws_db_subnet_group" "db" {
  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# ============================================================
# RDS POSTGRESQL
# ============================================================

resource "aws_db_instance" "postgres" {
  identifier        = "${var.project_name}-postgres"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "nimbuscart"
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db.id]

  publicly_accessible = false
  skip_final_snapshot = true
  deletion_protection = false
  multi_az            = false

  tags = {
    Name = "${var.project_name}-postgres"
    Tier = "db"
  }
}

# ============================================================
# APP DEPLOYMENT PROVISIONER
# ============================================================

resource "null_resource" "app_deployment" {
  depends_on = [
    aws_instance.web,
    aws_instance.app,
    aws_db_instance.postgres,
    aws_vpc_peering_connection.web_data
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/home/kirti/.ssh/terraform-key.pem")
    host        = aws_instance.web.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "../app/api/app.py"
    destination = "/tmp/app.py"
  }

  provisioner "file" {
    source      = "../app/api/requirements.txt"
    destination = "/tmp/requirements.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'NimbusCart API deployment provisioner executed'",
      "echo 'APP_PRIVATE_IP=${aws_instance.app.private_ip}'",
      "echo 'DB_ENDPOINT=${aws_db_instance.postgres.address}'"
    ]
  }
}
