#!/bin/bash

SG_IDS=$1
SUBNET_ID=$2

# Amazon Linux AMI 2014.09.1 (HVM) - ami-4985b048
AMI_ID=ami-e74b60e6
# amzn-ami-hvm-2014.09.1.x86_64 snap-025e7c85
SNAPSHOT_ID=snap-025e7c85

# Create EC2 Instance
# TODO: --security-group-ids $SG_IDS --subnet-id $SUBNET_ID
aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type t2.micro --iam-instance-profile Name=BatchProcessing --key-name gameday --user-data batch-processing-user-data.sh --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"DeleteOnTermination\":true,\"SnapshotId\":\"$SNAPSHOT_ID\",\"VolumeSize\":100,\"VolumeType\":\"standard\"}}]" > run-instance-out

INSTANCE_ID=`cat run-instance-out | grep InstanceId | awk -F\" '{print $4}'`

# Tag Instance
aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=Master

# Configure Security Group

# Review & Launch
