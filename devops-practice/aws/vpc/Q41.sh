#!/bin/bash
set -e
REGION=$(aws configure get region)
VPC=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --region "$REGION" --query 'Vpc.VpcId' --output text)
PUB=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.0.1.0/24 --region "$REGION" --query 'Subnet.SubnetId' --output text)
PRI=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.0.2.0/24 --region "$REGION" --query 'Subnet.SubnetId' --output text)
IGW=$(aws ec2 create-internet-gateway --region "$REGION" --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id "$VPC" --internet-gateway-id "$IGW" --region "$REGION"
EIP=$(aws ec2 allocate-address --domain vpc --region "$REGION" --query 'AllocationId' --output text)
NAT=$(aws ec2 create-nat-gateway --subnet-id "$PUB" --allocation-id "$EIP" --region "$REGION" --query 'NatGateway.NatGatewayId' --output text)
PUBRT=$(aws ec2 create-route-table --vpc-id "$VPC" --region "$REGION" --query 'RouteTableId' --output text)
PRIRT=$(aws ec2 create-route-table --vpc-id "$VPC" --region "$REGION" --query 'RouteTableId' --output text)
aws ec2 create-route --route-table-id "$PUBRT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW" --region "$REGION"
aws ec2 create-route --route-table-id "$PRIRT" --destination-cidr-block 0.0.0.0/0 --nat-gateway-id "$NAT" --region "$REGION"
aws ec2 associate-route-table --route-table-id "$PUBRT" --subnet-id "$PUB" --region "$REGION"
aws ec2 associate-route-table --route-table-id "$PRIRT" --subnet-id "$PRI" --region "$REGION"
aws ec2 modify-subnet-attribute --subnet-id "$PUB" --map-public-ip-on-launch --region "$REGION"
