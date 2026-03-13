#!/bin/bash
##
#
# start all VM in cloud, where vm_name begins 'test'
# script call 'start_vm.sh' script
#
##

cd "$(dirname "$0")" || exit 1

yc compute instance list | grep test | sed 's/|//g' | awk '{print($2)}' |
while read -r vm_name
do
  if [ -z "$vm_name" ]
  then
    echo "there is no VMs in cloud!"
    exit 0
  fi
  ./vm/start_vm.sh --vm-name "$vm_name" &
done

wait
echo "all VM started!"
yc compute instance list

cd - || exit 1

exit 0
