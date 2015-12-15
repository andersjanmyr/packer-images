#!/bin/bash

public_ip=$(curl 169.254.169.254/2014-11-05/meta-data/public-ipv4)
private_ip=$(curl 169.254.169.254/2014-11-05/meta-data/local-ipv4)
public_hostname=$(curl 169.254.169.254/2014-11-05/meta-data/public-hostname)

openssl genrsa -out server-key.pem 4096
openssl req -subj "/CN=$public_hostname" -sha256 -new \
  -key server-key.pem -out server.csr
echo subjectAltName = IP:$private_ip,IP:$public_ip,IP:127.0.0.1 > extfile.cnf
openssl x509 -req -days 365 -sha256 -in server.csr \
  -CA ca.pem -CAkey ca-key.pem -extfile extfile.cnf \
  -CAcreateserial -out server-cert.pem -passin file:ca-password.txt

chmod 0400 server-key.pem
chmod 0444 server-cert.pem

openssl genrsa -out swarm-key.pem 4096
openssl req -passin file:ca-password.txt -subj "/CN=$public_hostname" -new -key swarm-key.pem -out swarm-client.csr
echo 'extendedKeyUsage = clientAuth,serverAuth' > extfile.cnf
openssl x509 -passin file:ca-password.txt -req -days 365 -in swarm-client.csr -CA ca.pem -CAkey ca-key.pem -out swarm-cert.pem -extfile extfile.cnf

chmod 0400 server-key.pem swarm-key.pem
chmod 0444 server-cert.pem swarm-cert.pem
rm *.csr extfile.cnf
