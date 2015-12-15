#!/bin/bash

set -o errexit
token=$1

sudo docker run -d \
  -p 3376:2375 \
  -v /etc/docker:/etc/docker \
  --restart=always \
  --name swarm-manager \
  swarm:latest \
  manage \
  --tlsverify --tlscacert=/etc/docker/ca.pem \
  --tlscert=/etc/docker/swarm-cert.pem \
  --tlskey=/etc/docker/swarm-key.pem \
  $token

