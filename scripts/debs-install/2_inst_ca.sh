#!/bin/bash
##
#
# Script install CA server
#
##

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-ca test-ca || exit 1

cd - || exit 1

exit 0
