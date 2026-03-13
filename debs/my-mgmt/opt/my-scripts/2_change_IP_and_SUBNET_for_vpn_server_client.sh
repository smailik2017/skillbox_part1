#!/bin/bash
# shellcheck disable=SC2029
##
#
# Script sets IP for VPN and INTERNAL_SUBNET in template for creating ovpn files
#
##

VPN_IP=$(ssh test-vpn "curl -s ifconfig.me")
INTERNAL_SUBNET=$(ip -4 addr show eth0 | grep -oP 'inet \K[\d.]+' | cut -f1,2,3 -d '.')'.0'

ssh test-ca "sed -i 's/VPN-IP/$VPN_IP/g' /opt/my-scripts/tmpl/client_tmpl.ovpn"
ssh test-vpn "sudo cp /etc/openvpn/server_conf.tmpl /etc/openvpn/server.conf; sudo sed -i 's/SUBNET/$INTERNAL_SUBNET/g' /etc/openvpn/server.conf"
