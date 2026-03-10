#!/bin/bash
##
#
# Script install VPN server
#
##

cd "$(dirname "$0")"/../../debs/

mgmt="test-mgmt-ext"

[ -f "./my-vpn.deb" ] && rm "./my-vpn.deb"

dpkg-deb --build my-vpn

rm ~/.ssh/known_hosts
while ! ssh-keyscan $mgmt >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

while ! ssh $mgmt "ssh-keyscan -H test-vpn >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-vpn to known_hosts"
  sleep 100
done

while ! ssh $mgmt "ssh test-vpn \"sudo dpkg -l iptables-persistent &> /dev/null \""
do
  echo "INFO: Package 'iptables-persistent' sill not installed on test-vpn."
  echo "INFO: Waiting ..."
  sleep 100
done

# move package my-vpn.deb to mgmt
if ! scp ./my-vpn.deb $mgmt:~
then
  echo "ERROR: Some errors during copying my-vpn.deb to $mgmt"
  exit 1
fi
rm ./my-vpn.deb

# move package my-vpn.deb to test-vpn and delete it from test-mgmt
if ! ssh $mgmt "scp ./my-vpn.deb test-vpn:~ && rm -vf ./my-vpn.deb"
then 
  echo "ERROR: Some errors during move my-vpn.deb from test-mgmt to test-vpn"
  exit 1
fi

# remove packages before install if exists
if ssh $mgmt "ssh test-vpn \"sudo dpkg -l my-vpn &> /dev/null\""
then
  if ! ssh $mgmt "ssh test-vpn \"sudo apt purge my-vpn -y\""
  then
    echo "ERROR: Some errors during remove my-vpn package from test-vpn"
    exit 1
  fi
fi

# install package my-vpn and delete deb package from test-vpn
if ! ssh $mgmt "ssh test-vpn \"sudo apt --fix-broken install ./my-vpn.deb -y && rm -vf ./my-vpn.deb\""
then
  echo "ERROR: Some errors during install my-vpn package and delete deb from test-vpn"
  exit 1
fi

echo "VPN ready to work"

cd -

exit 0