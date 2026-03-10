#!/bin/bash
##
#
# script creates VM in cloud (test-ca, test-vpn, test-mgmt, test-web, test-mon)
# script call 'create_vm_local.sh' and 'create_vm.sh'
#
##
cd "$(dirname "$0")"

./vm/create_vm_local.sh --vm-name test-ca --vm-yaml-file ./vm/yaml/ca.yaml &
./vm/create_vm.sh --vm-name test-vpn --vm-yaml-file ./vm/yaml/vpn.yaml &
./vm/create_vm.sh --vm-name test-mgmt --vm-yaml-file ./vm/yaml/mgmt.yaml &
./vm/create_vm_local.sh --vm-name test-mon --vm-yaml-file ./vm/yaml/mon.yaml &

wait
echo "all VM created."
yc compute instance list

./sethosts.sh

cd -
