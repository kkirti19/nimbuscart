aws iam create-user --user-name q26-user
aws iam attach-user-policy --user-name q26-user --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam attach-user-policy --user-name q26-user --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-user-policy --user-name q26-user --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
aws iam list-users
