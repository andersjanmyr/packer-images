#!/bin/bash
(cd /etc/docker && /usr/local/bin/generate-server-keys.sh)
sudo service docker restart

