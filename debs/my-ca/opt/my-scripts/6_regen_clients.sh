#!/bin/bash
##
#
# This script regenerate CA and generate new clients
#
##

CA_DIR=/opt/ca
SCRIPTS=/opt/my-scripts

# dekete old clients
sudo rm -rf ~/vpn-clients

# regen all clients
find /opt/ca/clients -type f -exec basename {} .ovpn \; |
while read client
do
  $SCRIPTS/3_create_client.sh $client
done

# update CRL file
$SCRIPTS/5_update_crl.sh
