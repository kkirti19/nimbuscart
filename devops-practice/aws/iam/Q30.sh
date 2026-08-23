cat > users.csv <<'DATA'
username,policy
q30-user1,AmazonS3ReadOnlyAccess
q30-user2,AmazonEC2FullAccess
DATA
while IFS=, read -r user policy
do
[ "$user" = "username" ] && continue
[[ "$user" =~ ^[a-zA-Z0-9._-]+$ ]] || continue
aws iam get-user --user-name "$user" >/dev/null 2>&1 || aws iam create-user --user-name "$user"
aws iam attach-user-policy --user-name "$user" --policy-arn "arn:aws:iam::aws:policy/$policy"
done < users.csv
