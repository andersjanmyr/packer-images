#!/bin/bash
(cd /etc/docker && /usr/local/bin/generate-server-keys.sh)
sudo service docker restart

token=token://2bf0b7377c78a8461dee399551f0ae74
/usr/local/bin/start-swarm-manager.sh $token
