#!/bin/bash
##
#
# Script checks base packages installed
#
##

mgmt="test-mgmt-ext"

# test-mgmt
while ! ssh $mgmt "ssh-keyscan -H test-mgmt >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-mgmt to known_hosts"
  exit 1
done

while ! ssh $mgmt "ssh test-mgmt \"sudo dpkg -l my-mgmt &> /dev/null \""
do
  echo "INFO: Package 'my-mgmt' not installed on test-mgmt."
  exit 1
done

# test-mon
while ! ssh $mgmt "ssh-keyscan -H test-mon >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-mon to known_hosts"
  exit 1
done

while ! ssh $mgmt "ssh test-mon \"sudo dpkg -l my-mon &> /dev/null \""
do
  echo "INFO: Package 'my-mon' not installed on test-mon."
  exit 1
done

# test-ca
while ! ssh $mgmt "ssh-keyscan -H test-ca >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-ca to known_hosts"
  exit 1
done

while ! ssh $mgmt "ssh test-ca \"sudo dpkg -l my-ca &> /dev/null \""
do
  echo "INFO: Package 'my-ca' not installed on test-ca."
  exit 1
done

# test-vpn
while ! ssh $mgmt "ssh-keyscan -H test-vpn >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add test-vpn to known_hosts"
  exit 1
done

while ! ssh $mgmt "ssh test-vpn \"sudo dpkg -l my-vpn &> /dev/null \""
do
  echo "INFO: Package 'my-vpn' not installed on test-vpn."
  exit 1
done

while ! ssh $mgmt "ssh test-vpn \"sudo dpkg -l my-vpn-mon &> /dev/null \""
do
  echo "INFO: Package 'my-vpn-mon' not installed on test-vpn."
  exit 1
done

cd - || exit 1

echo "INFO: All base packages installed on servers."

exit 0
