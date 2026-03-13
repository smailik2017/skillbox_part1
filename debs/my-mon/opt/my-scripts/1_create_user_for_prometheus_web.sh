#!/bin/bash
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

# generate bcrypt password
pass=$(htpasswd -nb -B -C 10 "" "$2" | tr -d ':\n')

# add config to web.yml
sudo sed -i '/basic_auth_users/,$d' /etc/prometheus/web.yml
echo "basic_auth_users:" | sudo tee -a /etc/prometheus/web.yml &> /dev/null
echo "  $1: \"$pass\"" | sudo tee -a /etc/prometheus/web.yml &> /dev/null

# add cpnfig to prometheus.yml
sudo cp /etc/prometheus/prometheus.tmpl /etc/prometheus/prometheus.yml
sudo sed -i "s/^.*username.*$/      username: '$1'/" /etc/prometheus/prometheus.yml
sudo sed -i "s/^.*password.*$/      password: '$2'/" /etc/prometheus/prometheus.yml

# restart prometheus and prometheus alerter
sudo systemctl restart prometheus
sudo systemctl restart prometheus-alertmanager

exit 0
