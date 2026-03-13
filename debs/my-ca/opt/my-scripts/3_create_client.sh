#!/bin/bash
##
#
# $1 - client name
#
##

if [ -z "$1" ] 
then
  echo "Enter client name as parameter."
  echo "EXAMPLE: 3_create_client.sh client1"
  exit 1
fi

CA_DIR=/opt/ca
SCRIPT_DIR=/opt/my-scripts
outfile=$CA_DIR/clients/$1.ovpn

if [ ! -d "$CA_DIR" ]
then
  echo "There is no $CA_DIR directory!"
  echo "please read README first !!!"
  exit 1
fi

cd $CA_DIR || exit 1
# generate secrets
./easyrsa --batch gen-req "$1" nopass
./easyrsa --batch sign-req client "$1"

# generate ovpn file
{
  cat "$SCRIPT_DIR/tmpl/client_tmpl.ovpn"
  echo "<ca>"
  cat "$CA_DIR/pki/ca.crt"
  echo "</ca>"
  echo "<cert>"
  cat "$CA_DIR/pki/issued/$1.crt"
  echo "</cert>"
  echo "<key>"
  cat "$CA_DIR/pki/private/$1.key"
  echo "</key>" 
} > "$outfile"

exit 0
