#!/bin/bash
##
#
# Script install VPN-exporter
#
##

cd "$(dirname "$0")"/../../debs/ || exit 1

mgmt="test-mgmt-ext"

[ -f "./my-prometheus-openvpn-exporter.deb" ] && rm "./my-prometheus-openvpn-exporter.deb"

dpkg-deb --build my-prometheus-openvpn-exporter

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

# move package my-prometheus-openvpn-exporter.deb to mgmt
if ! scp ./my-prometheus-openvpn-exporter.deb $mgmt:~
then
  echo "ERROR: Some errors during copying my-prometheus-openvpn-exporter.deb to $mgmt"
  exit 1
fi
rm ./my-prometheus-openvpn-exporter.deb

# move package my-prometheus-openvpn-exporter.deb to test-vpn and delete it from test-mgmt
if ! ssh $mgmt "scp ./my-prometheus-openvpn-exporter.deb test-vpn:~ && rm -vf ./my-prometheus-openvpn-exporter.deb"
then 
  echo "ERROR: Some errors during move my-prometheus-openvpn-exporter.deb from test-mgmt to test-vpn"
  exit 1
fi

# remove packages before install if exists
if ssh $mgmt "ssh test-vpn \"sudo dpkg -l my-prometheus-openvpn-exporter &> /dev/null\""
then
  if ! ssh $mgmt "ssh test-vpn \"sudo apt purge my-prometheus-openvpn-exporter -y\""
  then
    echo "ERROR: Some errors during remove my-prometheus-openvpn-exporter package from test-vpn"
    exit 1
  fi
fi

# install package my-prometheus-openvpn-exporter and delete deb package from test-vpn
if ! ssh $mgmt "ssh test-vpn \"sudo apt --fix-broken install ./my-prometheus-openvpn-exporter.deb -y && rm -vf ./my-prometheus-openvpn-exporter.deb\""
then
  echo "ERROR: Some errors during install my-prometheus-openvpn-exporter package and delete deb from test-vpn"
  exit 1
fi

echo "VPN-exporter ready to work"

cd - || exit 1

exit 0