#!/bin/bash

VPC_ID=$1

GROUP_NAME='NAT Security Group'

OLD_GROUP=`aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID,Name=group-name,Values=$GROUP_NAME" | grep 'GroupId' | grep -oE '\"[^ "]*\"$' | sed s/\"//g`

if [ -n "$OLD_GROUP" ]; then
    echo 'Deleting old NAT security group'
    aws ec2 delete-security-group --group-id "$OLD_GROUP"
fi

# Create security group for NAT
GROUP_ID=`aws ec2 create-security-group --group-name "$GROUP_NAME" --description 'Security group for NAT instance' --vpc-id "$VPC_ID"  | grep 'GroupId' | grep -oE '\"[^ "]*\"$' | sed s/\"//g`

# Create inbound HTTP access rule
aws ec2 authorize-security-group-ingress --group-id "$GROUP_ID" --protocol tcp --port 80 --cidr 10.0.1.0/24 

# Create inbound HTTPS access rule
aws ec2 authorize-security-group-ingress --group-id  "$GROUP_ID" --protocol tcp --port 443 --cidr 10.0.1.0/24

# Create inbound SSH
aws ec2 authorize-security-group-ingress --group-id "$GROUP_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0

SUBNET_ID=`aws ec2 create-subnet --availability-zone ap-northeast-1c --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 | grep 'SubnetId' | grep -o 'subnet-[a-z0-9]*'`

echo 'Creating NAT instance'
aws ec2 run-instances --key-name gameday --instance-type m1.small --placement AvailabilityZone=ap-northeast-1c --image-id ami-11d6e610 --subnet-id $SUBNET_ID --security-group-ids $GROUP_ID
