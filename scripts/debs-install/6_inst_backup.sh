#!/bin/bash
##
#
# Script install backup script on sll servers
#
##

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-backup test-mgmt
./helper/inst_package.sh my-backup test-ca
./helper/inst_package.sh my-backup test-vpn
./helper/inst_package.sh my-backup test-mon

cd - || exit 1

exit 0
