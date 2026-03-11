#!/bin/bash
##
#
# script creates ssh keys timeweb to access servers
#
##

ssh-keygen -t ed25519 -C "smailik@example.com" -f ~/.ssh/timeweb

cd -
