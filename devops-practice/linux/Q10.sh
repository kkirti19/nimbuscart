systemctl status nginx
systemctl start nginx
systemctl restart nginx
systemctl stop nginx
systemctl enable nginx
mkdir -p ~/nginx-backup
cp /etc/nginx/nginx.conf ~/nginx-backup/
top -b -n 1 | head
free -h
df -h
