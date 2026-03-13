#!/bin/bash
##
#
# script creates VM in cloud (test-ca, test-vpn, test-mgmt, test-web, test-mon)
# script call 'create_vm_local.sh' and 'create_vm.sh'
# $1 - public key for acces to VM
#
##

if [ -z "$1" ]
then
  echo "give public keys as parameter."
  echo "EXAMPLE: ./create_all_vm.sh ~/.ssh/timeweb.pub"
  exit 1
fi

cd "$(dirname "$0")" || exit 1

./vm/create_vm_local.sh --vm-name test-ca --vm-yaml-file ./vm/yaml/ca.yaml_tmpl --vm-public-key "$1" &
./vm/create_vm.sh --vm-name test-vpn --vm-yaml-file ./vm/yaml/vpn.yaml_tmpl --vm-public-key "$1" &
./vm/create_vm.sh --vm-name test-mgmt --vm-yaml-file ./vm/yaml/mgmt.yaml_tmpl --vm-public-key "$1" &
./vm/create_vm_local.sh --vm-name test-mon --vm-yaml-file ./vm/yaml/mon.yaml_tmpl --vm-public-key "$1" &

echo "all VM created."
yc compute instance list

./sethosts.sh

cd - || exit 1

exit 0
