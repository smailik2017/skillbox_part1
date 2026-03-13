#!/bin/bash
##
#
# Script generates server certificate
#
##

CA_DIR=/opt/ca
cd $CA_DIR || exit 1

./easyrsa --batch gen-req server nopass
./easyrsa --batch sign-req server server

exit 0
