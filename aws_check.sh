#!/bin/bash

export AWS_DEFAULT_REGION=us-east-1

# Check instances
aws ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[*].Instances[*].[InstanceId]" --output table