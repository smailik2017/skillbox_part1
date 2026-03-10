#!/bin/bash
##
#
# Script generates server certificate
#
##

CA_DIR=/opt/ca
cd $CA_DIR

./easyrsa --batch gen-req server nopass
./easyrsa --batch sign-req server server
