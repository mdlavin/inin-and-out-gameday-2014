#!/bin/bash

VPC_ID=$1
SUBNET_ID=$2

GROUP_NAME='BatchProcessing'

OLD_GROUP=`aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID,Name=group-name,Values=$GROUP_NAME" | grep 'GroupId' | grep -oE '\"[^ "]*\"$' | sed s/\"//g`

if [ -n "$OLD_GROUP" ]; then
    echo 'Deleting old NAT security group'
    aws ec2 delete-security-group --group-id "$OLD_GROUP"
fi

# Create security group for batch procesing
GROUP_ID=`aws ec2 create-security-group --group-name "$GROUP_NAME" --description 'Batch Processing' --vpc-id "$VPC_ID"  | grep 'GroupId' | grep -oE '\"[^ "]*\"$' | sed s/\"//g`

# Create inbound SSH
aws ec2 authorize-security-group-ingress --group-id "$GROUP_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0

# Amazon Linux AMI 2014.09.1 (HVM) - ami-4985b048
AMI_ID=ami-4985b048
# amzn-ami-hvm-2014.09.1.x86_64 snap-025e7c85
SNAPSHOT_ID=snap-025e7c85

# Create EC2 Instance
aws ec2 run-instances --subnet-id $SUBNET_ID --security-group-ids $GROUP_ID --image-id $AMI_ID --count 1 --instance-type t2.micro --iam-instance-profile Name=BatchProcessing --key-name gameday --user-data batch-processing-user-data.sh --block-device-mappings "[{\"DeviceName\":\"/dev/xvda\",\"Ebs\":{\"DeleteOnTermination\":true,\"SnapshotId\":\"$SNAPSHOT_ID\",\"VolumeSize\":100,\"VolumeType\":\"standard\"}}]" > run-instance-out

INSTANCE_ID=`cat run-instance-out | grep InstanceId | awk -F\" '{print $4}'`

# Tag Instance
aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=Master

# Configure Security Group

# Review & Launch
