#!/bin/bash

dir=${1:-.}
cd $dir

echo 'Removing ca-password, ca-password.txt'
rm ./ca-password.txt


