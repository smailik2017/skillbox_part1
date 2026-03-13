#!/bin/bash
##
#
# Script compiles openvpn_exporter binary
#
##

wget -P ~/ https://github.com/kumina/openvpn_exporter/archive/refs/tags/v0.3.0.tar.gz

tar xzvf v0.3.0.tar.gz
cd openvpn_exporter-0.3.0 || exit 1
sed -i 's/examples\/client.status,examples\/server2.status,examples\/server3.status/\/var\/log\/openvpn\/openvpn-status.log/g' ./main.go
sudo go build ./main.go
sudo cp ./main /usr/bin/openvpn_exporter

exit 0
