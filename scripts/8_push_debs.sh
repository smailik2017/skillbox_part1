#!/bin/bash
##
#
# Script install and preconfigures packages on servers
# Script starts from operator PC, 
# from wich there is an access by SSH to mgmt server with name test-mgmg-ext
# read README first !
#
##

cd "$(dirname "$0")"/debs-install/ || exit 1

if ! ./1_inst_mgmt.sh
then
  echo "Error executing 1_inst_mgmt.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./2_inst_ca.sh
then
  echo "Error executing 1_inst_ca.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./3_inst_vpn.sh
then
  echo "Error executing 1_inst_vpn.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./4_inst_vpn_mon.sh
then
  echo "Error executing 1_inst_vpn_mon.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

if ! ./5_inst_mon.sh
then
  echo "Error executing 1_inst_mon.sh, check logs!"
  echo "Exiting ..."
  exit 1
fi

cd - || exit 1

exit 0
