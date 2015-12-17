#!/bin/bash

docker run --rm -it \
  -v $PWD:/tmp \
  -w /tmp \
  buildpack-deps:jessie \
  $*
