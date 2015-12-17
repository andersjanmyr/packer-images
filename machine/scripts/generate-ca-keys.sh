#!/bin/bash
set -o errexit

dir=${1:-.}
cd $dir

echo 'Generating pseudo random ca-password, use it as input when asked'
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1 | tee ./ca-password.txt

echo 'Generating CA key, ca-key.pem, use ca-password as input'
openssl genrsa -aes256 -out ca-key.pem 4096

echo 'Generating CA certificate, ca-cert.pem'
subject='/C=SE/ST=Skane/L=Lund/O=SonyMobile/OU=Lifelog/CN=lifelog-dev.sonymobile.com'
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 \
   -subj $subject -out ca.pem -passin file:./ca-password.txt

chmod 0400 ca-key.pem ca-password.txt
chmod 0444 ca.pem
