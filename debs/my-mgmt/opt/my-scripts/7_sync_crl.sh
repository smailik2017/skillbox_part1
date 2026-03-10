#!/bin/bash
##
# Script updates CRL from CA to VPN
##

CA_DIR=/opt/ca
VPN_DIR=/etc/openvpn
SECRETS_TMP=~/secrets-tmp
SCRIPTS=/opt/my-scripts

# update CRL
ssh test-ca "sudo $SCRIPTS/5_update_crl.sh"

# making temporary dir on CA
ssh test-ca "mkdir $SECRETS_TMP"

# copy CRL to temporary dir on CA
ssh test-ca "sudo cp $CA_DIR/pki/crl.pem $SECRETS_TMP"
ssh test-ca "sudo chown -R smailik:smailik $SECRETS_TMP"

# move temporary dir from CA to VPN
scp -r test-ca:$SECRETS_TMP test-vpn:~
ssh test-ca "rm -rf $SECRETS_TMP"

# move all files in temporary dir to /etc/openvpn
ssh test-vpn "sudo cp $SECRETS_TMP/* $VPN_DIR"
ssh test-vpn "rm -rf $SECRETS_TMP"

# set permissions
ssh test-vpn "sudo chown -R root:openvpn /etc/openvpn; sudo chmod -R 640 /etc/openvpn"

# restart openvpn@server
ssh test-vpn "sudo systemctl restart openvpn@server"
