#!/bin/bash

INPUT_QUEUE=`aws sqs create-queue --queue-name input --attributes VisibilityTimeout=90 | grep QueueUrl | grep -o 'http.*/input'`
echo "Created input queue $INPUT_QUEUE"

aws sqs create-queue --queue-name output --attributes VisibilityTimeout=90

aws sqs add-permission --label 'Incoming messages from Amazon' --queue-url "$INPUT_QUEUE" --actions "SendMessage" --aws-account-ids 526039161745

