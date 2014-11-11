#!/bin/bash

VPC_ID=`aws ec2 create-vpc --cidr-block 10.0.1.0/24 | grep VpcId | grep -o vpc-[a-z0-9]*`

echo "Created VPC $VPC_ID"
./launch-nat.sh $VPC_ID
