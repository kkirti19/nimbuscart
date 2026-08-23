B=q46-$(date +%s)
R=$(aws configure get region)
aws s3api create-bucket --bucket "$B" --region "$R" --create-bucket-configuration LocationConstraint="$R"
printf "Q46 S3 test\n" > q46.txt
aws s3 cp q46.txt s3://$B/
aws s3 ls s3://$B/
aws s3 rm s3://$B/q46.txt
aws s3api delete-bucket --bucket "$B"
