#!/bin/bash

docker run --rm -it -w /tmp/certs -v $PWD:/tmp buildpack-deps:jessie /tmp/generate-keys.sh
