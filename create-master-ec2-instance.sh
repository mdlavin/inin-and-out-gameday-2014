#!/bin/bash

VPC_ID=$1

# Amazon Linux AMI 2014.09.1 (HVM) - ami-4985b048
AMI_ID=ami-e74b60e6
# amzn-ami-hvm-2014.09.1.x86_64 snap-025e7c85
SNAPSHOT_ID=snap-025e7c85

# Create EC2 Instance
# TODO: Switch role to BatchProcessing
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --iam-instance-profile Name=hemp --user-data batch-processing-user-data.sh --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"DeleteOnTermination\":true,\"SnapshotId\":\"$SNAPSHOT_ID\",\"VolumeSize\":100,\"VolumeType\":\"standard\"}}]"

# Tag Instance
# aws ec2 create-tags --resources i-xxxxxxxx Master --tag "name=Master"

# Configure Security Group

# Review & Launch
