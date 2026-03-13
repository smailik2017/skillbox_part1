#!/bin/bash
##
# script deletes VM
#
# --vm-name <virtual machine name> - имя виртуальной машины
# EXAMPLE: ./delete_vm.sh --vm-name test-vm
#
##

# show help
function show_help {
  echo "--vm-name <virtual machine name> - имя виртуальной машины"
  echo "EXAMPLE: ./delete_vm.sh --vm-name test-vm"
  echo "VM in cloud:"
  yc compute instance list
}

# check params
while [ -n "$1" ]
do
  case $1 in 
    "--vm-name")
      shift
      VM_NAME=$1
      shift
      ;;
    "--help")
      show_help
      exit 0
      ;;
    *)
      echo "Wrong parameter $1 !!!"
      exit 1
      ;;
  esac
done

# Не установлено название виртуальной машины
if [ -z "$VM_NAME" ] 
then
  echo "VM_NAME not set !!!"
  show_help
  exit 1
fi

echo "deleting VM: $VM_NAME"

yc compute instance delete "$VM_NAME"

exit 0
