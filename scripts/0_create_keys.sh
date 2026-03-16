#!/bin/bash
##
#
# script creates ssh keys timeweb to access servers
#
##

read -r -p "Enter your email addres (default: test@example.com): " EMAIL 
read -r -p "key name (default: test-infra): " KEYNAME 
[ -z "$EMAIL" ] && EMAIL="test@example.com"
[ -z "$KEYNAME" ] && KEYNAME="test-infra"

echo "Generating key pair with email: $EMAIL and name: $KEYNAME"

ssh-keygen -t ed25519 -C "$EMAIL" -f "$HOME/.ssh/$KEYNAME"

cd - || exit 1

exit 0
