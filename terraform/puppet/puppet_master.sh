#!/bin/bash
set -xe
apt update
apt install -y puppetserver
echo "*" > /etc/puppet/autosign.conf
echo "[server]" > /etc/puppet/puppet.conf
echo "autosign=true" > /etc/puppet/puppet.conf
echo "[main]" > /etc/puppet/puppet.conf
echo "server = puppet" >> /etc/puppet/puppet.conf
echo "127.0.0.1 puppet" >> /etc/hosts
systemctl enable puppetserver
systemctl start puppetserver
systemctl enable puppet
systemctl start puppet
