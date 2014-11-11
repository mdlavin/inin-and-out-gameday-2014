#!/bin/bash

# First arg is security group id
SG=$1
# Second arg is AMI id
AMI=ami-e72f17e6
# Third arg is subnet id (e.g. subnet-k1345k5)
SUBNET_ID=$2

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LAUNCH_NAME=Workers_$(uuidgen)
ASG_NAME=Workers_ASG_$(uuidgen)

#TODO: set correct ami id
aws autoscaling create-launch-configuration --launch-configuration-name $LAUNCH_NAME --image-id $AMI --instance-type t2.micro --iam-instance-profile BatchProcessing --user-data file://$DIR/user-data.sh --security-groups $SG --associate-public-ip-address

aws autoscaling create-auto-scaling-group --auto-scaling-group-name $ASG_NAME --min-size 1 --max-size 4 --launch-configuration-name $LAUNCH_NAME --vpc-zone-identifier $SUBNET_ID

aws autoscaling put-scaling-policy --auto-scaling-group-name $ASG_NAME --policy-name ScaleOut --scaling-adjustment 1 --adjustment-type ChangeInCapacity
