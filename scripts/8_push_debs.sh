#!/bin/bash
##
#
# Script install and preconfigures packages on servers
# Script starts from operator PC, 
# from wich there is an access by SSH to mgmt server with name test-mgmg-ext
#
##

# check connection to mgmt server
rm -vf ~/.ssh/known_hosts
while ! ssh-keyscan test-mgmt-ext >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

# copy access keys to mgmt server
scp ~/.ssh/timeweb test-mgmt-ext:~/.ssh
ssh test-mgmt-ext "chmod 600 ~/.ssh/timeweb"
scp ./scripts/config test-mgmt-ext:~/.ssh

# install packages
cd "$(dirname "$0")"/debs-install/ || exit 1

if ! ./1_inst_mgmt.sh
then
  echo "ERROR: Error executing 1_inst_mgmt.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./2_inst_ca.sh
then
  echo "ERROR: Error executing 1_inst_ca.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./3_inst_vpn.sh
then
  echo "ERROR: Error executing 1_inst_vpn.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./4_inst_vpn_mon.sh
then
  echo "ERROR: Error executing 1_inst_vpn_mon.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./5_inst_mon.sh
then
  echo "ERROR: Error executing 1_inst_mon.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./6_inst_backup.sh
then
  echo "ERROR: Error executing 1_inst_mon.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

cd - || exit 1

exit 0
