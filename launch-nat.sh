#!/bin/bash

aws ec2 run-instances --key-name gameday --instance-type m1.small --placement AvailabilityZone=ap-northeast-1c --image-id ami-11d6e610
