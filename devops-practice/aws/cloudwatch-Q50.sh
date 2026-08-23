ID=$(aws ec2 describe-instances --filters 'Name=instance-state-name,Values=running' --query 'Reservations[].Instances[0].InstanceId' --output text)
TOPIC=$(aws sns create-topic --name q50-alerts --query TopicArn --output text)
aws sns subscribe --topic-arn "$TOPIC" --protocol email --notification-endpoint YOUR_EMAIL
aws cloudwatch put-metric-alarm --alarm-name q50-high-cpu --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --evaluation-periods 1 --threshold 80 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value="$ID" --alarm-actions "$TOPIC"
aws cloudwatch describe-alarms --alarm-names q50-high-cpu
