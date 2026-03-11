#!/bin/bash
##
# Creating VM with public IP address
#
# --vm-name <virtual machine name> - имя виртуальной машины
# --vm-yaml-file <file.yaml> - конфигурация виртуальной машины
# --vm-public-key <file.pub> - public key
#
# EXAMPLE: ./create_vm.sh --vm-name test-vm --vm-yaml-file yaml/ca.yaml --vm-public-key ~/.ssh/timeweb.pub
#
##

# show help
function show_help {
  echo "--vm-name <virtual machine name> - имя виртуальной машины"
  echo "--vm-yaml-file <yaml file here> - имя файл с конфигом VM в формате YAML"
  echo "--vm-public-key <file.pub> - public key for ssh access"
  echo "EXAMPLE: ./create_vm.sh --vm-name test-vm --vm-yaml-file ./ca.yaml"
  echo "VMs in cloud:"
  yc compute instance list
}

# check params
while [ ! -z $1 ]
do
  case $1 in 
    "--vm-name")
      shift
      VM_NAME=$1
      shift
      ;;
    "--vm-yaml-file")
      shift
      VM_YAML=$1
      shift
      ;;
    "--vm-public-key")
      shift
      VM_PUBLIC_KEY=$1
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
if [ -z $VM_NAME ] 
then
  echo "VM_NAME not set !!!"
  show_help
  exit 1
fi

# Не указан файл настройки YAML
if [ -z $VM_YAML ] 
then
  echo "VM_YAML not set !!!"
  show_help
  exit 1
fi

# Не указан public key
if [ -z $VM_PUBLIC_KEY ] 
then
  echo "VM_PUBLIC_KEY not set or not exists!!!"
  show_help
  exit 1
fi

sed "s|<public>|$(cat "$VM_PUBLIC_KEY")|g" "$VM_YAML" > ${VM_YAML%?????}

# creating VM
echo "creating VM: $VM_NAME"
yc compute instance create \
  --name="$VM_NAME" \
  --hostname="$VM_NAME" \
  --zone=ru-central1-a \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-2404-lts,size=10G \
  --metadata-from-file user-data=${VM_YAML%?????}

rm ${VM_YAML%?????}
