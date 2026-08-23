name="Linux"
a=20
b=5
read -p "Enter number: " n
sum=$((a+b))
diff=$((a-b))
mul=$((a*b))
div=$((a/b))
mod=$((a%b))
date_now=$(date)
pwd_now=$(pwd)
printf "%s\n" "$name" "$n" "$sum" "$diff" "$mul" "$div" "$mod" "$date_now" "$pwd_now"
