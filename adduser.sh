#!/bin/bash

# Check if username argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi
cd $(dirname $0)

USERNAME=$1
FILE="telemt.toml"

# Generate a random 16-byte hex token (32 characters)
TOKEN=$(openssl rand -hex 16)

# Check if the configuration file exists
if [ ! -f "$FILE" ]; then
    echo "Error: $FILE not found."
    exit 1
fi

# Append the user line directly after the [access.users] section header
# Using sed to find the pattern and append (a) the new entry
sed -i "/^\[access.users\]/a ${USERNAME} = \"${TOKEN}\"" "$FILE"

echo "User '$USERNAME' successfully added to $FILE."
./listusers.sh | grep "$USERNAME "
docker compose restart telemt

