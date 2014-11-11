#!/bin/sh

# Install ImageMagick, the AWS SDK for Python, and create a directory
yum install -y ImageMagick
easy_install argparse
mkdir /home/ec2-user/jobs

# Download and install the batch processing script
# The following command must be on a single line
wget -O /home/ec2-user/image_processor.py https://us-west-2-aws-training.s3.amazonaws.com/architecting-lab-3-creating-a-batch-processing-cluster-3.1/static/image_processor.py
