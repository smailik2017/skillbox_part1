#!/bin/bash
##
#
# Universal backup script
# to backup VPN
# ./backup.sh /etc/openvpn vpn
#
##

if [ -z $1 ]
then
  echo "Give directory for backup as parameter"
  echo "EXAMPLE: ./backup.sh /etc/openvpn vpn"
  exit 1
fi

if [ -z $2 ]
then
  echo "Give prefix for backups as parameter"
  echo "EXAMPLE: ./backup.sh /etc/openvpn vpn"
  exit 1
fi

SRC=$1
PREFIX=$2
BACKUP_DIR=/opt/backups
BACKUPS_CNT=5

mkdir -p "$BACKUP_DIR"

FILES_CNT=$(ls "$BACKUP_DIR" | grep $PREFIX | wc -l)
BACKUP_FILE="$BACKUP_DIR/"$PREFIX"_$(date +%Y-%m-%d__%H%M%S__%s).tar.gz"

if (( FILES_CNT == BACKUPS_CNT ))
then
  MIN=$(find $BACKUP_DIR -type f -name $PREFIX* -exec basename {} .tar.gz \; | sed 's/_/ /g' | awk '{print $NF}' | sort -n | head -n 1)
  rm $BACKUP_DIR/$PREFIX*$MIN*
fi

if (( FILES_CNT > BACKUPS_CNT ))
then
  echo "error in you backup directory!!!"
  exit 1
fi

tar -czvf "$BACKUP_FILE" "$SRC"
