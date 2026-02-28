#!/bin/bash

SUFFIX=617669746f2e7275
HOST=81.4.108.145
PORT=443

cd $(dirname $0)

# tg://proxy?server=81.4.108.145&port=443&secret=ee81fcb8dd5aced8c8983813ef2c1aea99617669746f2e7275

FILE="telemt.toml"

# Check if the configuration file exists
if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found."
    exit 1
fi

# Use awk to parse the specific section
# 1. /\[access.users\]/ {flag=1; next} -> Start printing after finding the header
# 2. /^\[/ {flag=0} -> Stop printing when a new section starts
# 3. flag && /=/ -> If inside the section and the line contains an '=', process it
# 4. gsub(/[",]/, "", $3) -> Clean up quotes or potential trailing commas
awk -v suffix="$SUFFIX" -v host="$HOST" -v port="$PORT" '
    /^\[access.users\]/ {flag=1; next} 
    /^\[/ {flag=0} 
    flag && /=/ {
        user = $1
        key = $3A
        gsub(/["]/, "", key)
	url="tg://proxy?server=" host "&port=" port "&secret=ee" key suffix

        printf "%-12s %s %s\n", user, key, url 
    }
' "$FILE"
