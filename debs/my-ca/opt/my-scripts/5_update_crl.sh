#!/bin/bash
##
#
# Script update CRL file
#
##
CA_DIR=/opt/ca

cd $CA_DIR
./easyrsa --batch gen-crl
