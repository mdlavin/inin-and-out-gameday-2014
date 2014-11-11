#!/bin/bash

VPC_ID=`aws ec2 create-vpc --cidr-block 10.0.1.0/16 | grep VpcId | grep -o vpc-[a-z0-9]*`
echo "Created VPC $VPC_ID"

GATEWAY_ID=`aws ec2 create-internet-gateway | grep InternetGatewayId | grep -o "igw-[a-z0-9]*"`
echo "Created gateway $GATEWAY_ID"

aws ec2 attach-internet-gateway --internet-gateway-id $GATEWAY_ID --vpc-id $VPC_ID

ROUTE_TABLE_ID=`aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID | grep RouteTableId  | grep -o "rtb-[a-z0-9]*" | uniq`
echo "Found route table $ROUTE_TABLE_ID"

aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $GATEWAY_ID

PUBLIC_SUBNET_ID=`aws ec2 create-subnet --availability-zone ap-northeast-1c --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 | grep 'SubnetId' | grep -o 'subnet-[a-z0-9]*'`
echo "Created public subnet $SUBNET_ID"

PRIVATE_SUBNET_ID=`aws ec2 create-subnet --availability-zone ap-northeast-1c --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 | grep 'SubnetId' | grep -o 'subnet-[a-z0-9]*'`
echo "Created private subnet $SUBNET_ID"

./launch-nat.sh $VPC_ID $PUBLIC_SUBNET_ID
./create-master-ec2-instance.sh $VPC_ID $PRIVATE_SUBNET_ID
./create-sqs-queues.sh
./create-s3-bucket.sh
