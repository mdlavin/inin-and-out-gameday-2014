#!/bin/bash

VPC_ID=$1

# hvm-ssd/ubuntu-utopic-amd64-server-20141110
SNAPSHOT_ID=snap-4b21bccd

#Create EC2 Instance
aws ec2 run-instances ami-4985b048 --instance-type t2.micro $VPC_ID --subnet subnet_id --iam-profile BatchProcessing --user-data-file batch-processing-user-data.sh

# Attach EBS volume
aws ec2 create-volume --snapshot $SNAPSHOT_ID --type gp2

# Tag Instance

# Configure Security Group

# Review & Launch
