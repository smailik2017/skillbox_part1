#!/bin/bash
##
#
# Script creates client for openvpn server
#
##

if [ -z $1 ]
then
  echo "Give client name as parameter !"
  echo "EXAMPLE: 5_create_client.sh client1"
  exit 1
fi

SCRIPTS=/opt/my-scripts

# create client and copy ovpn file to home dir in mgmt server
ssh test-ca "sudo mkdir -p ~/vpn-clients"
ssh test-ca "sudo $SCRIPTS/3_create_client.sh $1; sudo cp /opt/ca/clients/$1.ovpn ~/vpn-clients"

mkdir -p ~/vpn-clients
scp test-ca:~/vpn-clients/$1.ovpn ~/vpn-clients
