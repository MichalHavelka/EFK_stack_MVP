#!/bin/bash
set -xe
apt update
apt install -y puppet-agent
echo "[main]" > /etc/puppet/puppet.conf
echo "server = puppet" >> /etc/puppet/puppet.conf
echo "${master_ip} puppet" >> /etc/hosts
sleep 60 # wait for puppetserver to be ready
systemctl enable puppet
systemctl start puppet
