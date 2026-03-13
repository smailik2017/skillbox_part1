#!/bin/bash
##
#
# Script start and config all
#
##

/opt/my-scripts/1_ca_generate_secrets.sh || exit 1
/opt/my-scripts/2_change_IP_and_SUBNET_for_vpn_server_client.sh || exit 1
/opt/my-scripts/3_copy_secrets_to_vpn.sh || exit 1
/opt/my-scripts/4_restart_vpn.sh || exit 1
/opt/my-scripts/8_create_clients_crt_key_for_prometheus.sh || exit 1

echo "You need:"
echo "1. Create user for monitoring."
echo "run script /opt/my-scripts/9_create_user_for_prometheus.sh <username> <password>"
echo "..."
echo "2. Generate VPN script."
echo "run script /opt/my-scripts/5_create_client.sh <client name>"
echo "..."
echo "My congratulations :)"

exit 0
