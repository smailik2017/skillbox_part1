#!/bin/bash
##
#
# Script install MGMT server
#
##

# prepare SHH access
scp ~/.ssh/timeweb test-mgmt-ext:~/.ssh
ssh test-mgmt-ext "chmod 600 ~/.ssh/timeweb"
scp ./scripts/config test-mgmt-ext:~/.ssh

# start install
cd "$(dirname "$0")" || exit 1

./helper/inst_package.sh my-mgmt test-mgmt || exit 1

cd - || exit 1

exit 0
