#!/bin/bash

mv gameday.pem gameday.pem.old
aws ec2 create-key-pair --key-name gameday --region ap-northeast-1 --query 'KeyMaterial' --output text > gameday.pem
