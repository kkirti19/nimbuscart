#!/bin/bash
set -e
R=$(aws configure get region)
VPC=$(aws ec2 create-vpc --cidr-block 10.10.0.0/16 --query 'Vpc.VpcId' --output text)
PUB=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.10.1.0/24 --query 'Subnet.SubnetId' --output text)
PRI=$(aws ec2 create-subnet --vpc-id "$VPC" --cidr-block 10.10.2.0/24 --query 'Subnet.SubnetId' --output text)
IGW=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id "$VPC" --internet-gateway-id "$IGW"
EIP=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
NAT=$(aws ec2 create-nat-gateway --subnet-id "$PUB" --allocation-id "$EIP" --query 'NatGateway.NatGatewayId' --output text)
PUBRT=$(aws ec2 create-route-table --vpc-id "$VPC" --query 'RouteTableId' --output text)
PRIRT=$(aws ec2 create-route-table --vpc-id "$VPC" --query 'RouteTableId' --output text)
aws ec2 create-route --route-table-id "$PUBRT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW"
aws ec2 create-route --route-table-id "$PRIRT" --destination-cidr-block 0.0.0.0/0 --nat-gateway-id "$NAT"
aws ec2 associate-route-table --route-table-id "$PUBRT" --subnet-id "$PUB"
aws ec2 associate-route-table --route-table-id "$PRIRT" --subnet-id "$PRI"
aws ec2 modify-subnet-attribute --subnet-id "$PUB" --map-public-ip-on-launch
aws ec2 describe-vpcs --vpc-ids "$VPC"
aws ec2 describe-subnets --subnet-ids "$PUB" "$PRI"
aws ec2 describe-nat-gateways --nat-gateway-ids "$NAT"
