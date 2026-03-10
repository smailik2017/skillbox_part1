#!/bin/bash
##
#
# This script initialize CA (CA, dh and CRL)
# generated clients in dir /opt/ca/clients
#
##
CA_DIR=/opt/ca

make-cadir $CA_DIR
mkdir -p $CA_DIR/clients
cd $CA_DIR
./easyrsa --batch clean-all
./easyrsa --batch init-pki
./easyrsa --batch build-ca nopass
./easyrsa --batch gen-dh
./easyrsa --batch gen-crl
