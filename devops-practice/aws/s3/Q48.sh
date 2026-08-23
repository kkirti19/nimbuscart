B=YOUR-UNIQUE-NAME-q40
R=$(aws configure get region)
URL="http://$B.s3-website-$R.amazonaws.com"
curl -I "$URL"
curl "$URL"
curl -I "$URL/notfound.html"
