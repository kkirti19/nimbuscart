cat > employees.csv <<'DATA'
Name,Department,Salary
John,IT,45000
Sara,HR,35000
Mike,Finance,50000
Anita,IT,42000
David,HR,38000
DATA
awk -F, 'NR>1 && $3>40000 {print $1,$3}' employees.csv
awk -F, 'NR>1 {sum+=$3;n++} END {print sum/n}' employees.csv
sed 's/,/|/g' employees.csv
sed 's/HR/Human Resources/g' employees.csv
sed '3d' employees.csv
