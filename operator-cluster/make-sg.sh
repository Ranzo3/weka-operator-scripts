
cluster=$myCluster

#Use Default
#vpcid=$(aws ec2 describe-vpcs --filters Name=is-default,Values=true --query 'Vpcs[0].VpcId' --output text)
vpcid=$myVPC
#subnet=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${vpcid} --query 'Subnets[0].SubnetId' --output text)
subnet=$myPrivateSubnet
subnetcidr=$(aws ec2 describe-subnets --filters Name=subnet-id,Values=${subnet} --query 'Subnets[0].CidrBlock' --output text)

secgrp=$(aws ec2 create-security-group --group-name ${cluster} --description ${cluster} --vpc-id ${vpcid} | jq -r '.GroupId')
aws ec2 authorize-security-group-ingress --group-id ${secgrp} --protocol \-1 --port \-1 --cidr ${subnetcidr}
aws ec2 authorize-security-group-egress --group-id ${secgrp} --protocol \-1 --port \-1 --cidr ${subnetcidr}
aws ec2 authorize-security-group-ingress --group-id ${secgrp} --protocol tcp --port 22 --cidr 0.0.0.0/0
echo ""
echo "New security group ${secgrp} created and ingress/egress rules added"
echo ""
