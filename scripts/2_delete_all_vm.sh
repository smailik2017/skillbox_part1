#!/bin/bash
##
#
# delete all VM in cloud, where vm_name begins 'test'
# script call 'delete_vm.sh' script
#
##

cd "$(dirname "$0")" || exit 1

yc compute instance list | grep test | sed 's/|//g' | awk '{print($2)}' |
while read -r vm_name
do
  if [ -z "$vm_name" ]
  then
    echo "there is no VMs in cloud!"
    exit 1
  fi
  ./vm/delete_vm.sh --vm-name "$vm_name" &
done

echo "all VM deleted!"
yc compute instance list

./delhosts.sh || exit 1

cd - || exit 1

exit 0
