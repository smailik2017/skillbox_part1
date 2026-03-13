#!/bin/bash
# shellcheck disable=SC2029
##
#
# Script creates user and password to acces prometheus
#
##

if [[ -z "$1" || -z "$2" ]]
then
	echo "you must specify username and password"
	echo "EXAMPLE: 1_create_user_for_prometheus_web.sh user p@ssw0rd"
	exit 1
fi

ssh test-mon "/opt/my-scripts/1_create_user_for_prometheus_web.sh $1 $2"

exit 0
