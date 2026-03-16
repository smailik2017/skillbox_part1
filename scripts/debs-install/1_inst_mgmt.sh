#!/bin/bash
##
#
# Script install MGMT server
# $1 - private key to manage all servere
# EXAMPLE: ./1_inst_mgmt.sh ~/.ssh/timeweb
#
##

# copy private to mgmt server
scp "$1" my-mgmt-ext:~/.ssh/

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-mgmt test-mgmt || exit 1

cd - || exit 1

exit 0
