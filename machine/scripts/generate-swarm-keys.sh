#!/bin/bash
set -o errexit

dir=${1:-.}
cd $dir

public_hostname=$(curl 169.254.169.254/2014-11-05/meta-data/public-hostname)

openssl genrsa -out swarm-key.pem 4096
openssl req -passin file:ca-password.txt -subj "/CN=$public_hostname" -new -key swarm-key.pem -out swarm-client.csr
echo 'extendedKeyUsage = clientAuth,serverAuth' > swarm-ext.cnf
openssl x509 -req -days 365 \
  -passin file:ca-password.txt \
  -in swarm-client.csr \
  -CA ca.pem -CAkey ca-key.pem \
  -extfile swarm-ext.cnf \
  -out swarm-cert.pem

chmod 0400 swarm-key.pem
chmod 0444 swarm-cert.pem
rm *.csr *.cnf
