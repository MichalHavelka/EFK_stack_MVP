#!/bin/bash

source .env

## SETUP EFK_STACK
ssh -o StrictHostKeychecking=no -i ../../key.pem admin@$efk_stack_ec2_2 "sudo apt update && sudo apt install -y rsync net-tools dnsutils htop"
rsync -av --mkpath -e "ssh -i ../../key.pem" --rsync-path="sudo rsync" setup_efk/* admin@${efk_stack_ec2_2}:/opt/efk-stack/
ssh -o StrictHostKeyChecking=no -i ../../key.pem admin@$efk_stack_ec2_2 "curl -fsSL https://get.docker.com -o get-docker.sh && \\
 sudo sh get-docker.sh && \\
 sudo docker compose -f /opt/efk-stack/docker-compose.yml up -d"

## SETUP FORWARDER
ssh -o StrictHostKeychecking=no -i ../../key.pem admin@$forwarder_ec2_3 "sudo apt update && sudo apt install -y rsync net-tools dnsutils htop"
rsync -av --mkpath -e "ssh -i ../../key.pem" --rsync-path="sudo rsync" setup_forwarder/* admin@${forwarder_ec2_3}:/opt/forwarder/
ssh -o StrictHostKeyChecking=no -i ../../key.pem admin@$forwarder_ec2_3 "curl -fsSL https://get.docker.com -o get-docker.sh && \\
 sudo sh get-docker.sh && \\
 sudo docker compose -f /opt/forwarder/docker-compose.yml up -d"

## SETUP KAFKA
ssh -o StrictHostKeychecking=no -i ../../key.pem admin@$kafka_ec2_1 "sudo apt update && sudo apt install -y rsync net-tools dnsutils htop"
rsync -av --mkpath -e "ssh -i ../../key.pem" --rsync-path="sudo rsync" setup_kafka/* admin@${kafka_ec2_1}:/opt/kafka/
ssh -o StrictHostKeyChecking=no -i ../../key.pem admin@$kafka_ec2_1 "curl -fsSL https://get.docker.com -o get-docker.sh && \\
 sudo sh get-docker.sh && \\
 sudo docker compose -f /opt/kafka/docker-compose.yml up -d"
