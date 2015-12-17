#!/bin/bash
set -o errexit

dir=${1:-.}
cd $dir

public_ip=$(curl 169.254.169.254/2014-11-05/meta-data/public-ipv4)
private_ip=$(curl 169.254.169.254/2014-11-05/meta-data/local-ipv4)
public_hostname=$(curl 169.254.169.254/2014-11-05/meta-data/public-hostname)

echo 'Generating server-key.pem'
openssl genrsa -out server-key.pem 4096
echo 'Generating server signing request server.csr'
openssl req -subj "/CN=$public_hostname" -sha256 -new \
  -key server-key.pem \
  -out server.csr
echo subjectAltName = IP:$private_ip,IP:$public_ip,IP:127.0.0.1 > server-ext.cnf
echo 'Generating server certificate, server-cert.pem'
openssl x509 -req -days 365 -sha256 \
  -passin file:ca-password.txt \
  -in server.csr \
  -CA ca.pem -CAkey ca-key.pem \
  -extfile server-ext.cnf \
  -CAcreateserial \
  -out server-cert.pem

chmod 0400 server-key.pem
chmod 0444 server-cert.pem
rm *.csr *.cnf
