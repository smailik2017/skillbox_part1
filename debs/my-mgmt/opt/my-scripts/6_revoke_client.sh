#!/bin/bash
##
#
# Script revoke client
#
##

if [ -z $1 ]
then
  echo "Give client name as parameter !"
  echo "EXAMPLE: 6_revoke_client.sh client1"
  exit 1
fi

SCRIPTS=/opt/my-scripts

# revoke client and update CRL
ssh test-ca "sudo $SCRIPTS/4_revoke_client.sh $1; sudo $SCRIPTS/5_update_crl.sh"
rm ~/vpn-clients/$1.ovpn
