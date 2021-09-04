#!/bin/bash

if [ -z "${ROLE_PREFIX+x}" ]; then
  echo "Please define \$ROLE_PREFIX before continuning"
  exit -1
fi

for name in `aws iam list-roles | jq -r .Roles[].RoleName | grep ^$ROLE_PREFIX`; do 
  
  echo "Processing role: $name"

  for profile in ` aws iam list-instance-profiles-for-role --role-name $name | jq -r .InstanceProfiles[].InstanceProfileName`; do
    aws iam remove-role-from-instance-profile --instance-profile-name $profile --role-name $name
    
    echo "Deleting instance profile: $profile"
    aws iam delete-instance-profile --instance-profile-name $profile
  done

  for policy in `aws iam list-attached-role-policies --role-name $name | jq -r .AttachedPolicies[].PolicyArn`; do
    aws iam detach-role-policy --role-name $name --policy-arn $policy
    echo "Deleting policy: $policy"
    aws iam delete-policy --policy-arn $policy
  done 

  for policy in `aws iam list-role-policies --role-name $name | jq -r .PolicyNames[]`; do 
    echo "Deleting role policy: $policy"
    aws iam delete-role-policy --role-name $name --policy-name $policy
  done	  

  echo "Deleting role: $name"
  aws iam delete-role --role-name $name
done

for policy in `aws iam list-policies  | jq -r .Policies[].Arn | egrep "^arn:aws:iam::[0-9]+:policy/$ROLE_PREFIX"`; do 
  echo "Deleting policy: $policy"
  aws iam delete-policy --policy-arn $policy
done