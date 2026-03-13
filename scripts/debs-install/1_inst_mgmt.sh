#!/bin/bash
##
#
# Script install MGMT server
#
##
rm ~/.ssh/known_hosts

cd "$(dirname "$0")"/../../debs/ || exit 1

mgmt="test-mgmt-ext"

[ -f "./my-mgmt.deb" ] && rm "./my-mgmt.deb"

dpkg-deb --build my-mgmt

rm ~/.ssh/known-hosts
while ! ssh-keyscan $mgmt >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

while ! ssh $mgmt "sudo dpkg -l | grep iptables-persistent &> /dev/null"
do
  echo "INFO: Package 'iptables-persistent' sill not installed on test-mgmt."
  echo "INFO: Waiting ..."
  sleep 100
done

ssh $mgmt "ssh-keyscan test-mgmt >> ~/.ssh/known_hosts"

# move package my-mgmt.deb to mgmt
if ! scp ./my-mgmt.deb $mgmt:~
then
  echo "ERROR: Some errors during copying my-mgmt.deb to $mgmt"
  exit 1
fi
rm ./my-mgmt.deb

# remove packages before install
if ssh $mgmt "sudo dpkg -l my-mgmt &> /dev/null"
then
  if ! ssh $mgmt "sudo apt purge my-mgmt -y"
  then
    echo "ERROR: Could remove my-mgmt package"
    exit 1
  fi
fi

# install packages
if ! ssh $mgmt "sudo apt --fix-broken install ./my-mgmt.deb -y && rm -vf ./my-mgmt.deb"
then
  echo "ERROR: Some errors while installing my-mgmt.deb on $mgmt"
  exit 1
fi

echo "OK: MGMT ready to work"

cd - || exit 1

exit 0
