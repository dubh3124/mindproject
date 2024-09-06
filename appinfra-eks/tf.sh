#!/bin/bash

ACTION=$1
ENVIRONMENT=$2

case $ACTION in

init)
  rm -rf .terraform/; terraform init -var-file=vars/$ENVIRONMENT.tfvars -backend-config=backends/$ENVIRONMENT.backend
  ;;

plan)
  rm -rf .terraform/; terraform init -var-file=vars/$ENVIRONMENT.tfvars -backend-config=backends/$ENVIRONMENT.backend; terraform $ACTION -var-file=vars/$ENVIRONMENT.tfvars
  ;;

apply | destroy)
 terraform init -var-file=vars/$ENVIRONMENT.tfvars -backend-config=backends/$ENVIRONMENT.backend; terraform $ACTION -var-file=vars/$ENVIRONMENT.tfvars -auto-approve
  ;;

*)
  echo "Oops!"
  ;;

esac