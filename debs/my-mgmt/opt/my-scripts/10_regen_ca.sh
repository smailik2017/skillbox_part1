#!/bin/bash
##
#
# script regenerate CA and all clients to home
#
##

SCRIPTS=/opt/my-scripts
CA_DIR=/opt/ca

$SCRIPTS/1_ca_generate_secrets.sh
$SCRIPTS/2_change_IP_and_SUBNET_for_vpn_server_client.sh
$SCRIPTS/3_copy_secrets_to_vpn.sh
$SCRIPTS/4_restart_vpn.sh
rm -rf ~/vpn-clients

# resign clients
ssh test-ca "sudo $SCRIPTS/6_regen_clients.sh"

# copy clients ovpn files to ~/vpn-clients
ssh test-ca "sudo rm -rf ~/vpn-clients; sudo mkdir -p ~/vpn-clients; sudo find /opt/ca/clients -type f -name *.ovpn -exec sudo cp {} ~/vpn-clients \;; sudo chown -R smailik:smailik ~/vpn-clients"

scp -r test-ca:~/vpn-clients ~
