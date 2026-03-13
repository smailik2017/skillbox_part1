#!/bin/bash
# shellcheck disable=SC2029
##
#
# Script install package to server
#
# $1 - package name (without .deb, just name)
# $2 - server name
#
# EXAMPLE: ./inst_package.sh my-ca test-ca
#
##

# check parameters
if [ -z "$1" ]
then
  echo "Give package name as psrameter!"
  echo "EXAMPLE: ./inst_package.sh my-ca test-ca"
fi

if [ -z "$2" ]
then
  echo "Give server name as psrameter!"
  echo "EXAMPLE: ./inst_package.sh my-ca test-ca"
fi

mgmt="test-mgmt-ext"
# go to DEBS dir
cd "$(dirname "$0")"/../../../debs/ || exit 1

# remove deb package if exists
[ -f "$1.deb" ] && rm -vf "$1.deb"

# build package
dpkg-deb --build "$1"

# check connection to mgmt server
rm -vf ~/.ssh/known_hosts
while ! ssh-keyscan $mgmt >> ~/.ssh/known_hosts
do
  echo "INFO: Could not connect to mgmt server."
  echo "INFO: Waiting ..."
  sleep 100
done

# move package to mgmt
if ! scp "$1.deb" $mgmt:~
then
  echo "ERROR: Some errors during copying $1.deb to $mgmt"
  exit 1
fi
rm -vf "$1.deb"

# install on server
while ! ssh $mgmt "ssh-keyscan -H $2 >> ~/.ssh/known_hosts"
do
  echo "INFO: Could not add $2 to known_hosts on $mgmt"
  exit 1
done
# move package from mgmt to server if not test-mgmt
if [ "$2" != "test-mgmt" ]
then
  if ! ssh $mgmt "scp $1.deb $2:~ && rm -vf $1.deb"
  then 
    echo "ERROR: Some errors during move $1.deb from test-mgmt to $2"
    exit 1
  fi
fi
# remove packages on server before install
if ssh $mgmt "ssh $2 \"sudo dpkg -l $1 &> /dev/null\""
then
  if ! ssh $mgmt "ssh $2 \"sudo apt purge $1 -y\""
  then
    echo "ERROR: Some errors during remove $1 package from $2"
    exit 1
  fi
fi
# install package and delete deb package from server
if ! ssh $mgmt "ssh $2 \"sudo apt --fix-broken install ./$1.deb -y && rm -vf $1.deb\""
then
  echo "ERROR: Some errors during install $1 package and delete deb from $2"
  exit 1
fi
echo "INFO: $1 package installed on $2 successfully."

cd - || exit 1

exit 0
