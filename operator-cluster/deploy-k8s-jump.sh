#!/bin/bash -e




#cluster=$1
#secgrp=$2
#keypair=$3
#ami=$4

#if [ $# != 4 ]; then
#    echo "Usage: $0 cluster secgrp keypair ami"
#    echo "   Ex: $0 ranzo-20241010 sg-08b1592679e647df9 cst-aws-key ami-013f45d263dc2da8d"
#    exit 1
#fi

cluster=$myCluster
secgrp=$mySecGrp
keypair=$myKeyPair
ami=ami-013f45d263dc2da8d  #Jump Box AMI

#Use Default
#vpcid=$(aws ec2 describe-vpcs --filters Name=is-default,Values=true --query 'Vpcs[0].VpcId' --output text)
vpcid=$myVPC

#subnet=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${vpcid} --query 'Subnets[0].SubnetId' --output text)
subnet=$myPublicSubnet
subnetcidr=$(aws ec2 describe-subnets --filters Name=subnet-id,Values=${subnet} --query 'Subnets[0].CidrBlock' --output text)

# Set up boot-time script (userdata)
userdata64="IyEvYmluL2Jhc2ggLWUKbWtmcy5leHQ0IC1MIG9wdC13ZWthIC9kZXYvbnZtZTFuMQpta2RpciAtcCAvb3B0L3dla2EKbW91bnQgLUwgb3B0LXdla2EgL29wdC93ZWthCmVjaG8gIkxBQkVMPW9wdC13ZWthIC9vcHQvd2VrYSBleHQ0IGRlZmF1bHRzIDAgMiIgPj4vZXRjL2ZzdGFiCg=="

aws ec2 run-instances --count 1 --image-id ${ami} --instance-type t3.micro \
--cpu-options CoreCount=1,ThreadsPerCore=1 --ebs-optimized \
--user-data ${userdata64} \
--tag-specifications \
"ResourceType=instance,Tags=[{Key=Name,Value=${cluster}-jump}]" \
"ResourceType=volume,Tags=[{Key=Name,Value=${cluster}-jump}]" \
--key-name ${keypair} \
--network-interfaces \
"DeviceIndex=0,Groups=${secgrp},DeleteOnTermination=true,SubnetId=${subnet}"
