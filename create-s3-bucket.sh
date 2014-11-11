#!/bin/bash

aws s3api create-bucket --bucket image-bucket-`uuidgen|tr '[:upper:]' '[:lower:]'` --create-bucket-configuration LocationConstraint=ap-northeast-1
