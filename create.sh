#!/bin/bash

VPC_ID=`aws ec2 create-vpc --cidr-block 10.0.1.0/24 | grep VpcId | grep -o vpc-[a-z0-9]*`
echo "Created VPC $VPC_ID"

SUBNET_ID=`aws ec2 create-subnet --availability-zone ap-northeast-1c --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 | grep 'SubnetId' | grep -o 'subnet-[a-z0-9]*'`
echo "Created subnet $SUBNET_ID"

./launch-nat.sh $VPC_ID $SUBNET_ID
