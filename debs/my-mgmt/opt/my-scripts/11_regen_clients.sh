#!/bin/bash
# shellcheck disable=SC2029
##
#
# script regenerate CA and all clients to home
#
##

SCRIPTS=/opt/my-scripts
CA_DIR=/opt/ca

$SCRIPTS/2_change_IP_and_SUBNET_for_vpn_server_client.sh
$SCRIPTS/4_restart_vpn.sh

# del old clients
rm -rf ~/vpn-clients

# resign clients
ssh test-ca "sudo $SCRIPTS/6_regen_clients.sh"

# copy clients ovpn files to ~/vpn-clients
ssh test-ca "sudo rm -rf ~/vpn-clients; sudo mkdir -p ~/vpn-clients; sudo find $CA_DIR/clients -type f -name *.ovpn -exec sudo cp {} ~/vpn-clients \;; sudo chown -R smailik:smailik ~/vpn-clients"

# copy clients ovpn to mgmt
scp -r test-ca:~/vpn-clients ~

exit 0
