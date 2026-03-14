#!/bin/bash
##
#
# Script install MGMT server
#
##

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-mgmt test-mgmt || exit 1

cd - || exit 1

exit 0
