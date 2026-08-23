B=YOUR-UNIQUE-NAME-q40
R=$(aws configure get region)
aws s3api create-bucket --bucket "$B" --region "$R" --create-bucket-configuration LocationConstraint="$R"
aws s3 cp index.html s3://$B/
aws s3 cp error.html s3://$B/
aws s3 website s3://$B/ --index-document index.html --error-document error.html
