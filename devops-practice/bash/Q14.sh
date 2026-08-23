disk=$(df / | awk 'NR==2 {gsub("%","",$5);print $5}')
if [ "$disk" -gt 80 ]; then
printf "CRITICAL\n"
else
printf "NORMAL\n"
fi
