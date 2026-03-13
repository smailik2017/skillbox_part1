#!/bin/bash

yc compute instance list | grep test | sed 's/|//g' | awk '{print $NF " " $2}' |
while read -r line
do
  vm=$(echo "$line" | cut -f 2 -d " ")
  sudo sed -i "/$vm/d" /etc/hosts
  echo "$line" | sudo tee -a /etc/hosts
done

if [ ! "$(grep -c test /etc/hosts)" -eq 4 ]
then
  echo "Not all VM in cloud!"
  echo "Check your cloud!"
  exit 1
fi

vm=$(yc compute instance list | grep test-mgmt | sed 's/|//g' | awk '{print $(NF - 1)}')

sudo sed -i "/test-mgmt-ext/d" /etc/hosts
echo "$vm test-mgmt-ext" | sudo tee -a /etc/hosts

exit 0
