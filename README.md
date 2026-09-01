# NimbusCart

NimbusCart is a cloud-based e-commerce infrastructure project that demonstrates the deployment and automation of a web application using AWS, Docker, and Terraform.

## Project Overview

The project sets up a multi-tier cloud infrastructure for the NimbusCart application. Infrastructure provisioning and configuration are automated using Terraform, while Docker is used to containerize the application.

The project includes:

- Frontend web application
- Python-based backend API
- Docker containerization
- AWS cloud infrastructure
- Terraform infrastructure as code
- VPC networking and subnet configuration
- VPC peering and routing
- Automated application deployment using Terraform provisioners

## Technologies Used

- AWS
- Terraform
- Docker
- Docker Compose
- Python
- Flask
- HTML
- JavaScript
- Linux
- Git & GitHub
- Shell Scripting

## Project Structure

```text
nimbuscart/
├── app/
│   ├── api/
│   │   ├── app.py
│   │   ├── Dockerfile
│   │   └── requirements.txt
│   └── frontend/
│       └── index.html
├── terraform/
│   ├── backend.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── script.sh
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── .terraform.lock.hcl
├── docker-compose.yml
├── main.tf
└── .gitignore

## Infrastructure

The AWS infrastructure is managed using Terraform and includes:

- VPC configuration
- Public and private subnets
- Internet Gateway
- Route tables
- Security groups
- VPC peering
- EC2-based application infrastructure
- Database subnet configuration
- Automated provisioning

## Docker

Docker is used to containerize the application components.

The backend API is packaged using a Dockerfile, while Docker Compose is used to manage the application services.

### Docker Components

- Backend API container
- Dockerfile for the Python Flask API
- Docker Compose configuration
- Containerized application deployment

### Docker Commands

```bash
docker build -t nimbuscart-api ./app/api
docker compose up -d
docker ps
docker compose down

## Terraform

Terraform is used as Infrastructure as Code (IaC) to provision and manage the AWS infrastructure.

The Terraform configuration manages:

- AWS provider configuration
- VPC and subnet configuration
- Route tables
- Security groups
- VPC peering
- EC2 infrastructure
- Database subnet configuration
- Application deployment
- Provisioning scripts

## AWS

The project uses AWS to provide the cloud infrastructure required for the application.

AWS components include:

- VPC
- Public and private subnets
- Internet Gateway
- Route tables
- Security groups
- VPC peering
- EC2 instances
- Database subnets

## Networking

The project demonstrates AWS networking concepts including:

- VPC configuration
- Public and private subnet configuration
- Route tables
- Internet Gateway
- Security groups
- VPC peering
- Routing between network components

## Application Deployment

The application deployment is automated using Terraform and Docker.

The deployment process includes:

1. Provisioning the AWS infrastructure using Terraform.
2. Creating and configuring the required network resources.
3. Provisioning the application infrastructure.
4. Copying required application files to the provisioned resources.
5. Executing remote deployment commands.
6. Running the application using Docker.

## Infrastructure as Code (IaC)

Terraform is used to define the infrastructure as code instead of manually creating AWS resources.

This makes the infrastructure:

- Repeatable
- Automated
- Easier to manage
- Easier to modify
- Consistent across deployments

## Provisioning

Terraform provisioners are used to automate configuration and deployment tasks on the provisioned infrastructure.

The project uses:

- File provisioners
- Remote-exec provisioners
- Application deployment commands
- Automated configuration scripts

## Shell Scripting

Shell scripting is used to automate deployment and configuration tasks.

The project includes:

```text
terraform/script.sh

## Version Control

Git is used for version control, while GitHub is used to host and manage the project source code.

Repository:

https://github.com/kkirti19/nimbuscart

## Technologies Used

- AWS
- Terraform
- Docker
- Docker Compose
- Python
- Flask
- HTML
- JavaScript
- Linux
- Shell Scripting
- Git
- GitHub

## Learning Outcomes

This project provided practical exposure to:

- AWS cloud infrastructure
- Infrastructure as Code using Terraform
- AWS VPC networking
- Subnets and route tables
- Security groups
- VPC peering
- EC2 infrastructure
- Docker containerization
- Docker Compose
- Linux commands
- Shell scripting
- Automated provisioning
- Application deployment
- Git and GitHub version control

## Author

Kirti

GitHub:

https://github.com/kkirti19
