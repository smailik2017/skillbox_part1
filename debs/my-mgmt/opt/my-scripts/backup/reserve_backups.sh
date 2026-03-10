#!/bin/bash
##
#
# sync backup to mgmt server
# script sync backup dirs on remote servers to home
#
##

SRC_DIR=/opt/backups/
RESERVE_DIR=~/reserve_backups

ssh-keysddcan test-mgmt >> ~/.ssh/known_hosts
ssh-keyscan test-mon >> ~/.ssh/known_hosts
ssh-keyscan test-vpn >> ~/.ssh/known_hosts
ssh-keyscan test-ca >> ~/.ssh/known_hosts

mkdir -p $RESERVE_DIR

rsync -avh -e ssh test-mgmt:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-ca:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-vpn:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-mon:$SRC_DIR $RESERVE_DIR
