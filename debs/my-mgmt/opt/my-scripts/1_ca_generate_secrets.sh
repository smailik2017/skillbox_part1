#!/bin/bash
##
#
# script initialize CA server for working
#
##

SCRIPTS=/opt/my-scripts

ssh test-ca "sudo $SCRIPTS/1_create_init_and_create_ca.sh"
ssh test-ca "sudo $SCRIPTS/2_create_server_keys.sh"
