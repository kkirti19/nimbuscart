cat > regex.txt <<'DATA'
Sonia
Samantha
Sarah
John
Jason
Aruna
TestT100String
192.168.1.10
10.0.0.25
172.16.5.100
DATA
grep '^A' regex.txt
grep 'a$' regex.txt
grep '^S.*a$' regex.txt
grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' regex.txt
grep -oE '[0-9]+' regex.txt
sed 's/i/ii/g' regex.txt
