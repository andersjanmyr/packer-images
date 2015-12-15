#!/bin/bash

set -o errexit

token=$1

ip=$(ifconfig | grep -C3 eth0 |awk '/inet addr/{print substr($2,6)}')

sudo docker run -d \
  -v /etc/docker:/etc/docker \
  --restart=always \
  --name swarm-agent \
  swarm:latest \
  join  \
  --advertise ${ip}:2376 \
  --tlsverify --tlscacert=/etc/docker/ca.pem \
  --tlscert=/etc/docker/cert.pem \
  --tlskey=/etc/docker/key.pem \
  $token


