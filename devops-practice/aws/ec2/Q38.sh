KEY=q38-key
SG=q38-sg
aws ec2 create-key-pair --key-name "$KEY" --query KeyMaterial --output text > "$KEY.pem"
chmod 400 "$KEY.pem"
aws ec2 create-security-group --group-name "$SG" --description "$SG"
SGID=$(aws ec2 describe-security-groups --group-names "$SG" --query 'SecurityGroups[0].GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id "$SGID" --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id "$SGID" --protocol tcp --port 80 --cidr 0.0.0.0/0
AMI=$(aws ec2 describe-images --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*' 'Name=state,Values=available' --query 'sort_by(Images,&CreationDate)[-1].ImageId' --output text)
aws ec2 run-instances --image-id "$AMI" --instance-type t2.micro --key-name "$KEY" --security-group-ids "$SGID" --count 5 --user-data '#!/bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx'
