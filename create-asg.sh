#!/bin/bash

# First arg is security group id
SG=$1
# Second arg is AMI id
AMI=$2
# Third arg is VPC id (e.g. subnet-k1345k5)
VPC=$3

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#TODO: set correct ami id
aws autoscaling create-launch-configuration --launch-configuration-name Workers --image-id $AMI --instance-type t2.micro --iam-instance-profile BatchProcessing --user-data file://$DIR/user-data.sh --security-groups $SG

aws autoscaling create-auto-scaling-group --auto-scaling-group-name worker-group --min-size 1 --max-size 4 --launch-configuration-name Workers --vpc-zone-identifier $VPC

aws autoscaling put-scaling-policy --auto-scaling-group-name worker-group --policy-name ScaleIn --scaling-adjustment -1 --adjustment-type ChangeInCapacity
aws autoscaling put-scaling-policy --auto-scaling-group-name worker-group --policy-name ScaleOut --scaling-adjustment 1 --adjustment-type ChangeInCapacity
