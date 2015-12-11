#!/bin/bash

echo 'Generating pseudo random ca-password, use it as input when asked'
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | tee ./ca-password.txt

echo 'Generating ca-key, use ca-password as input'
openssl genrsa -aes256 -out ca-key.pem 4096

subject='/C=SE/ST=Skane/L=Lund/O=SonyMobile/OU=Lifelog/CN=lifelog-dev.sonymobile.com'
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 \
   -subj $subject -out ca.pem -passin file:./ca-password.txt

openssl genrsa -out key.pem 4096
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > extfile.cnf
openssl x509 -req -days 365 -sha256 -in client.csr \
  -CA ca.pem -CAkey ca-key.pem -CAcreateserial -extfile extfile.cnf \
  -out cert.pem -passin file:./ca-password.txt

chmod 0400 ca-key.pem key.pem ca-password.txt
chmod 0444 ca.pem cert.pem
rm client.csr extfile.cnf

