#!/bin/bash
##
#
# Script install VPN server
#
##

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-vpn test-vpn || exit 1

cd - || exit 1

exit 0
