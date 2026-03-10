#!/bin/bash
##
#
# Script install MON server
#
##

cd "$(dirname "$0")"/../../debs/

mgmt="test-mgmt-ext"

[ -f "./my-mon.deb" ] && rm "./my-mon.deb"

dpkg-deb --build my-mon

rm ~/.ssh/known_hosts
while ! ssh-keyscan $mgmt >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

while ! ssh $mgmt "ssh-keyscan -H test-mon >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-mon to known_hosts"
  sleep 100
done

while ! ssh $mgmt "ssh test-mon \"sudo dpkg -l iptables-persistent &> /dev/null \""
do
  echo "INFO: Package 'iptables-persistent' sill not installed on test-mon."
  echo "INFO: Waiting ..."
  sleep 100
done

# move package my-mon.deb to mgmt
if ! scp ./my-mon.deb $mgmt:~
then
  echo "ERROR: Some errors during copying my-mon.deb to $mgmt"
  exit 1
fi
rm ./my-mon.deb

# move package my-mon.deb to test-mon and delete it from test-mgmt
if ! ssh $mgmt "scp ./my-mon.deb test-mon:~ && rm -vf ./my-mon.deb"
then 
  echo "ERROR: Some errors during move my-mon.deb from test-mgmt to test-mon"
  exit 1
fi

# remove packages before install if exists
if ssh $mgmt "ssh test-mon \"sudo dpkg -l my-mon &> /dev/null\""
then
  if ! ssh $mgmt "ssh test-mon \"sudo apt purge my-mon -y\""
  then
    echo "ERROR: Some errors during remove my-mon package from test-mon"
    exit 1
  fi
fi

# install package my-mon and delete deb package from test-mon
if ! ssh $mgmt "ssh test-mon \"sudo apt --fix-broken install ./my-mon.deb -y && rm -vf ./my-mon.deb\""
then
  echo "ERROR: Some errors during install my-mon package and delete deb from test-mon"
  exit 1
fi

echo "MON ready to work"

cd -

exit 0