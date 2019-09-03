#!/bin/bash
#  This script ssh to aws ec2 with tag Name
if [ $# -ne 2 ] ; then
   echo "Usage: $0 TagName rootacct"
   echo "$0 bastion admin|centos"
   exit 1
fi

EC2acct=$2
EC2s=/tmp/EC2s.list
KEYPAIR=$HOME/toai-keypair.pem

aws ec2 describe-instances  --query 'Reservations[].Instances[].[PrivateIpAddress,PublicIpAddress,VpcId,InstanceId,Tags[?Key==`Name`].Value[]]' --output text --filters "Name=instance-state-name,Values=running" | sed 's/None$/None\n/g' | sed '$!N;s/\n/ /g' | nl  > $EC2s

IP=`cat $EC2s | grep $1 | head -n 1| awk '{print $3}'`
ssh -i $KEYPAIR $EC2acct@$IP
