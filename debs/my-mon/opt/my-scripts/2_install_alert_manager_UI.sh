#!/bin/bash
##
# Install prometheus-alertmanager UI
##

/usr/share/prometheus/alertmanager/generate-ui.sh
sudo systemctl restart prometheus-alertmanager
