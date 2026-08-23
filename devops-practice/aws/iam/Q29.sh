cat > trust.json <<'DATA'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
DATA
aws iam create-role --role-name q29-ec2-s3-role --assume-role-policy-document file://trust.json
aws iam attach-role-policy --role-name q29-ec2-s3-role --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam create-instance-profile --instance-profile-name q29-ec2-profile
aws iam add-role-to-instance-profile --instance-profile-name q29-ec2-profile --role-name q29-ec2-s3-role
