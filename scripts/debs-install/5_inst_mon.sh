#!/bin/bash
##
#
# Script install MON server
#
##

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-mon test-mon || exit 1

cd - || exit 1

exit 0
