#!/bin/bash
##
#
# Script update CRL file
#
##
CA_DIR=/opt/ca

cd $CA_DIR || exit 1
./easyrsa --batch gen-crl

exit 0
