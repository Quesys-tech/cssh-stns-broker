#!/bin/bash

# function EXPECT_EQ (A,B)
function EXPECT_EQ () {
  if [ "$1" == "$2" ]; then
    printf '\033[32m%s\033[m\n' 'OK'
  else
    printf '\033[31m%s\033[m\n' 'FAIL'
    exit 1
  fi
}

cd "$(dirname "$0")"
docker compose up -d --build
sleep 10

echo -n "Testing correct username and public key... "
RESULT=$(
curl -X POST http://localhost:8000/pubkey \
-H "Content-Type: application/json" \
-d '{
  "username": "foo",
  "publicKey":  "ssh-rsa qux",
  "connectionId": "1234",
  "remoteAddress": "192.0.2.1"
}'  2>/dev/null |  jq '.success' )
EXPECT_EQ "$RESULT" "true"

# wrong public key
echo -n "Testing correct username and wrong public key... "
RESULT=$(
curl -X POST http://localhost:8000/pubkey \
-H "Content-Type: application/json" \
-d '{
  "username": "foo",
  "publicKey":  "ssh-rsa askjdha", 
  "connectionId": "1234",
  "remoteAddress": "192.0.2.1"
}' 2>/dev/null |  jq '.success')
EXPECT_EQ "$RESULT" "false"

# wrong username 
echo -n "Testing wrong username and existing public key... "
RESULT=$(
curl -X POST http://localhost:8000/pubkey \
-H "Content-Type: application/json" \
-d '{
  "username": "gquuuuuux",
  "publicKey":  "ssh-rsa qux",
  "connectionId": "1234",
  "remoteAddress": "192.0.2.1"
}'  2>/dev/null | jq '.success')
EXPECT_EQ "$RESULT" "false"

docker compose down