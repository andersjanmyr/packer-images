#!/bin/bash
(cd /etc/docker && /usr/local/bin/generate-server-keys.sh)
sudo service docker stop
rm -f /etc/docker/key.json
sudo service docker start

token=token://2bf0b7377c78a8461dee399551f0ae74
/usr/local/bin/start-swarm-node.sh $token

echo DOCKER_OPTS='
-H tcp://0.0.0.0:2376
-H unix:///var/run/docker.sock
--storage-driver aufs
--tlsverify
--tlscacert /etc/docker/ca.pem
--tlscert /etc/docker/server-cert.pem
--tlskey /etc/docker/server-key.pem
--label provider=amazonec2
--label public=yes
' > /etc/default/docker
