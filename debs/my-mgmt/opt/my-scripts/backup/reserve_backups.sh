#!/bin/bash
##
#
# sync backup to mgmt server
# script sync backup dirs on remote servers to home
# and removes backups older 30 days (LIMIT variable)
#
##

SRC_DIR=/opt/backups/
RESERVE_DIR=~/reserve_backups
# remove files older 30 days
LIMIT=$(echo "30 * 24 * 60 * 60" | bc)

{
  ssh-keyscan test-mgmt
  ssh-keyscan test-mon
  ssh-keyscan test-vpn
  ssh-keyscan test-ca
} >> "$HOME/.ssh/known_hosts"

mkdir -p $RESERVE_DIR

rsync -avh -e ssh test-mgmt:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-ca:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-vpn:$SRC_DIR $RESERVE_DIR
rsync -avh -e ssh test-mon:$SRC_DIR $RESERVE_DIR

find $RESERVE_DIR -type f -exec basename {} .tar.gz \; | sed 's/_/ /g' | awk -v D1="$(date +%s)" -v L1="$LIMIT" 'D1-$NF>L1 {print}' | sed 's/ /_/g' |
while read -r line
do
  rm -vf $RESERVE_DIR/"$line".tar.gz
done

exit 0
