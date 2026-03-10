#!/bin/bash
##
#
# Script restart openvpn server
#
##

ssh test-vpn "sudo systemctl restart openvpn@server"
