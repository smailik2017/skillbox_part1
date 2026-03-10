#!/bin/bash
##
#
# Script install CA server
#
##

cd "$(dirname "$0")"/../../debs/

mgmt="test-mgmt-ext"

[ -f "./my-ca.deb" ] && rm "./my-ca.deb"

dpkg-deb --build my-ca

rm ~/.ssh/known_hosts
while ! ssh-keyscan $mgmt >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

while ! ssh $mgmt "ssh-keyscan -H test-ca >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-ca to known_hosts"
  sleep 100
done

while ! ssh $mgmt "ssh test-ca \"sudo dpkg -l iptables-persistent &> /dev/null \""
do
  echo "INFO: Package 'iptables-persistent' sill not installed on test-ca."
  echo "INFO: Waiting ..."
  sleep 100
done

# move package my-ca.deb to mgmt
if ! scp ./my-ca.deb $mgmt:~
then
  echo "ERROR: Some errors during copying my-ca.deb to $mgmt"
  exit 1
fi
rm ./my-ca.deb

# move package my-ca.deb to test-ca and delete it from test-mgmt
if ! ssh $mgmt "scp ./my-ca.deb test-ca:~ && rm -vf ./my-ca.deb"
then 
  echo "ERROR: Some errors during move my-ca.deb from test-mgmt to test-ca"
  exit 1
fi

# remove packages before install if exists
if ssh $mgmt "ssh test-ca \"sudo dpkg -l my-ca &> /dev/null\""
then
  if ! ssh $mgmt "ssh test-ca \"sudo apt purge my-ca -y\""
  then
    echo "ERROR: Some errors during remove my-ca package from test-ca"
    exit 1
  fi
fi

# install package my-ca and delete deb package from test-ca
if ! ssh $mgmt "ssh test-ca \"sudo apt --fix-broken install ./my-ca.deb -y && rm -vf ./my-ca.deb\""
then
  echo "ERROR: Some errors during install my-ca package and delete deb from test-ca"
  exit 1
fi

echo "CA ready to work"

cd -

exit 0