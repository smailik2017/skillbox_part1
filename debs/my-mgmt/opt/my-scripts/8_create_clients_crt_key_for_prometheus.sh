#!/bin/bash

# remove old crt and key
sudo rm /etc/prometheus-exporter/clients.*

# generate new crt and key on test-mgmt
sudo openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout /etc/prometheus-exporter/clients.key -out /etc/prometheus-exporter/clients.crt -subj "/C=RU/ST=Moscow/L=Test/O=Test-1/CN=localhost" -addext "subjectAltName = DNS:*.ru-central1.internal"

# set permissions
sudo chown -R prometheus:prometheus /etc/prometheus-exporter
sudo chmod 640 /etc/prometheus-exporter/clients.key
sudo chmod 640 /etc/prometheus-exporter/clients.crt

# restart node-exporter
sudo systemctl restart prometheus-node-exporter

# copy crt and key to tmp dir
sudo mkdir ~/tmp
sudo cp /etc/prometheus-exporter/clients.* ~/tmp
sudo chown -R smailik:smailik ~/tmp

# move crt and key to servers
scp -r ~/tmp test-vpn:~
scp -r ~/tmp test-ca:~
scp -r ~/tmp test-mon:~

sudo rm -rf ~/tmp

# add key and crt to node-exporter on vpn
ssh test-vpn "sudo cp ~/tmp/clients.key /etc/prometheus-exporter"
ssh test-vpn "sudo cp ~/tmp/clients.crt /etc/prometheus-exporter"
ssh test-vpn "sudo chown -R prometheus:prometheus /etc/prometheus-exporter; sudo rm -rf ~/tmp"
ssh test-vpn "sudo systemctl restart prometheus-node-exporter"

# add key and crt to node-exporter on ca
ssh test-ca "sudo cp ~/tmp/clients.key /etc/prometheus-exporter"
ssh test-ca "sudo cp ~/tmp/clients.crt /etc/prometheus-exporter"
ssh test-ca "sudo chown -R prometheus:prometheus /etc/prometheus-exporter; sudo rm -rf ~/tmp"
ssh test-ca "sudo systemctl restart prometheus-node-exporter"

# add key and crt to node-exporter on mon
ssh test-mon "sudo cp ~/tmp/clients.key /etc/prometheus-exporter"
ssh test-mon "sudo cp ~/tmp/clients.crt /etc/prometheus-exporter"
ssh test-mon "sudo chown -R prometheus:prometheus /etc/prometheus-exporter"
ssh test-mon "sudo systemctl restart prometheus-node-exporter"
ssh test-mon "sudo rm -rf ~/tmp"

# restart nginx and prometheus on test-mon
ssh test-mon "sudo systemctl restart nginx"
ssh test-mon "sudo systemctl restart prometheus"

exit 0
