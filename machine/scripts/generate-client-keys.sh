#!/bin/bash
set -o errexit

dir=${1:-.}
cd $dir

echo 'Generating client key, key.pem'
openssl genrsa -out key.pem 4096
echo 'Generating client signing request, client.csr'
openssl req -subj '/CN=client' -new -key key.pem -out client.csr
echo extendedKeyUsage = clientAuth > client-ext.cnf

echo 'Generating client cert, cert.pem'
openssl x509 -req -days 365 -sha256 -in client.csr \
  -CA ca.pem -CAkey ca-key.pem -CAcreateserial -extfile client-ext.cnf \
  -out cert.pem -passin file:./ca-password.txt

chmod 0400 key.pem
chmod 0444 cert.pem
rm client.csr client-ext.cnf

