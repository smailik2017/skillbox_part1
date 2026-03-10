#!/bin/bash
##
#
# Script install and preconfigures packages on servers
# Script starts from operator PC, 
# from wich there is an access by SSH to mgmt server with name test-mgmg-ext
# read README first !
#
##

cd "$(dirname "$0")"/debs-install/

./1_inst_mgmt.sh
./2_inst_ca.sh
./3_inst_vpn.sh
./4_inst_vpn_mon.sh
./5_inst_mon.sh

cd -
