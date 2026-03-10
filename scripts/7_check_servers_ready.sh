#!/bin/bash
##
#
# Script check that servers are ready to work
#
##

cd "$(dirname "$0")"

hosts=$(cat /etc/hosts | grep test-mgmt | sed 's/|//g' | awk '{print($2)}')
if [[ ! "$hosts" == *"mgmt"* ]]
then
  echo "mgmt hosts not exists in your /etc/hosts"
  echo "check your virtual hosts in cloud and rerun 5_sethosts.sh"
  exit 1
fi

hosts=$(cat /etc/hosts | grep test | grep -v mgmt | sed 's/|//g' | awk '{print($2)}')
if [ ! $(echo $hosts | wc -w) -eq 3 ]
then
  echo "there is not all hosts in your /etc/hosts"
  echo "check your virtual hosts in cloud and rerun 5_sethosts.sh"
  exit 1
fi

mgmt="test-mgmt-ext"

while ! ssh-keyscan -H $mgmt
do 
  sleep 100
done
rm ~/.ssh/known_hosts
ssh-keyscan -H $mgmt >> ~/.ssh/known_hosts

ssh $mgmt "sudo rm ~/.ssh/known_hosts"

echo $hosts |
while read vm_name
do
  while ! ssh $mgmt "ssh-keyscan -H $vm_name"
  do
    sleep 100
  done
  ssh $mgmt "ssh-keyscan -H $vm_name >> ~/.ssh/known_hosts"
done

cd -
