ls -l employees.csv
wc -l employees.csv
cut -d, -f1 employees.csv
cut -d, -f2 employees.csv | sort | uniq
cut -d, -f3 employees.csv | tail -n +2 | sort -n
awk -F, 'NR>1 && $3>40000 {print $1,$3}' employees.csv
awk -F, 'NR>1 {print $1,$2}' employees.csv | sort
sed 's/,/|/g' employees.csv
cut -d, -f2 employees.csv | tail -n +2 | sort | uniq | wc -l
