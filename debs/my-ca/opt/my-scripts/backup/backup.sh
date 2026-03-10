#!/bin/bash
##
#
# Universal backup script
# to backup CA
# ./backup.sh /opt/ca ca
#
##

if [ -z $1 ]
then
  echo "Give directory for backup as parameter"
  echo "EXAMPLE: ./backup.sh /opt/my-scripts mgmt"
  exit 1
fi

if [ -z $2 ]
then
  echo "Give prefix for backups as parameter"
  echo "EXAMPLE: ./backup.sh /opt/my-scripts mgmt"
  exit 1
fi

SRC=$1
PREFIX=$2
BACKUP_DIR=/opt/backups
BACKUPS_CNT=5

mkdir -p "$BACKUP_DIR"

FILES_CNT=$(ls "$BACKUP_DIR" | grep $PREFIX | wc -l)
echo "Backup files: $FILES_CNT"
if (( FILES_CNT < BACKUPS_CNT ))
then
  BACKUP_FILE="$BACKUP_DIR/$((FILES_CNT + 1))_"$PREFIX"_$(date +%Y-%m-%d__%H%M%S).tar.gz"
fi

if (( FILES_CNT == BACKUPS_CNT ))
then
  rm -vf $BACKUP_DIR/1_*
  BACKUP_FILE="$BACKUP_DIR/"$BACKUPS_CNT"_"$PREFIX"_$(date +%Y-%m-%d__%H%M%S).tar.gz"
  find $BACKUP_DIR -type f | grep $PREFIX | grep -v "1_" |
  while read file
  do
    NUM=$(echo $(basename $file) | cut -f 1 -d "_")
    NEW_NAME=$(echo "$file" | sed "s/"$NUM"_/"$(( NUM - 1 ))"_/")
    mv $file $NEW_NAME
  done
fi

if (( FILES_CNT > BACKUPS_CNT ))
then
  echo "error in you backup directory!!!"
  exit 1
fi


tar -czvf "$BACKUP_FILE" "$SRC"
