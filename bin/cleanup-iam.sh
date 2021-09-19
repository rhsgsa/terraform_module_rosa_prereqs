#!/bin/bash

if [ -z "${ROLE_PREFIX+x}" ]; then
  echo "Please define \$ROLE_PREFIX to delete before continuning"
  exit -1
fi

RED=$'\e[0;31m'
NC='\033[0m' # No Color

opt_dry_run=false
while :; do
    case $1 in
        --dry-run) 
          opt_dry_run=true
          echo -e "${RED}***IN DRY RUN MODE***${NC}"
        ;;
        *) break
    esac
    shift
done

if "$opt_dry_run"; then
    cmd="echo -e ${RED}> DRYRUN: $*${NC}"
else
    cmd=''
fi

echo "Using ROLE_PREFIX: $ROLE_PREFIX"

for name in `aws iam list-roles | jq -r .Roles[].RoleName | grep ^$ROLE_PREFIX-`; do 
  
  echo "Processing IAM role: $name"

  for profile in `aws iam list-instance-profiles-for-role --role-name $name | jq -r .InstanceProfiles[].InstanceProfileName`; do
    echo "Removing IAM role: $name from instance profile: $profile"
    $cmd aws iam remove-role-from-instance-profile --instance-profile-name $profile --role-name $name
    echo "Deleting IAM instance profile: $profile"
    $cmd aws iam delete-instance-profile --instance-profile-name $profile
  done

  for policy in `aws iam list-attached-role-policies --role-name $name | jq -r .AttachedPolicies[].PolicyArn`; do
    echo "Detaching IAM policy: $policy from role: $name"
    $cmd aws iam detach-role-policy --role-name $name --policy-arn $policy
    echo "Deleting IAM policy: $policy"
    $cmd aws iam delete-policy --policy-arn $policy
  done 

  for policy in `aws iam list-role-policies --role-name $name | jq -r .PolicyNames[]`; do 
    echo "Deleting IAM role policy: $policy"
    $cmd aws iam delete-role-policy --role-name $name --policy-name $policy
  done	  

  echo "Deleting IAM role: $name"
  $cmd aws iam delete-role --role-name $name
  echo 
done

for policy in `aws iam list-policies  | jq -r .Policies[].Arn | egrep "^arn:aws:iam::[0-9]+:policy/$ROLE_PREFIX"`; do 
  echo "Deleting IAM policy: $policy"
  $cmd aws iam delete-policy --policy-arn $policy
done