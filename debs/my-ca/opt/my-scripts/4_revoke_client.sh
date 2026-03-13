#!/bin/bash
##
#
# $1 - client name
#
##

if [ -z "$1" ] 
then
  echo "Enter client name as parameter."
  echo "EXAMPLE: 4_revoke_client.sh client1"
  exit 1
fi

CA_DIR=/opt/ca

if [ ! -d "$CA_DIR" ]
then
  echo "There is no $CA_DIR directory!"
  echo "please read README first !!!"
  exit 1
fi

cd $CA_DIR || exit 1
./easyrsa --batch revoke "$1"

rm "./clients/$1.ovpn"
rm "$HOME/vpn-clients/$1.ovpn"

exit 0
