dir="$1"
latest=$(find "$dir" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
printf "%s\n" "$latest"
tr -cs '[:alnum:]' '\n' < "$latest" | tr '[:upper:]' '[:lower:]' | sort | uniq -c | sort -nr | head -1
