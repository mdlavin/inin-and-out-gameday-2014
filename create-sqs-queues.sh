#!/bin/bash

aws sqs create-queue --queue-name input --attributes VisibilityTimeout=90
aws sqs create-queue --queue-name output --attributes VisibilityTimeout=90

