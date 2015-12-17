#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
rm -rf certs
mkdir -p certs
$DIR/run-in-debian.sh ./scripts/generate-ca-keys.sh certs
$DIR/run-in-debian.sh ./scripts/generate-client-keys.sh certs
packer build ubuntu.json
