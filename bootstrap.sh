#!/bin/bash

set -e
set -o pipefail

unset action
unset filepath
unset id
unset url

tfdirs="networking appinfra nlpcicd"


Help(){
   # Display Help
   echo "This script builds out the entire Project, by running all needed Terraform deployments. "
   echo
   echo "Syntax: ./bootstrap.sh [-a|i|f|h]"
   echo "options:"
   echo "a     Creates, tests or destroy the Project. *NOTE* Choices are  (create|test|destroy) *NOTE* Use 'test' action after creating the project"
   echo "t     Execute tests to showcase functionality. *NOTE* Use After creating the project"
   echo "i     (Use with Test flag (-t)) Device ID for API request"
   echo "f     (Use with Test flag (-t)) File to upload"
   echo "h     Print this Help."
   echo
}

exit_with_help()
{
  Help
  exit 1
}

reverse(){
  tr ' ' '\n'<<<"$@"|tac|tr '\n' ' ';
}


create(){
  for tfdir in $tfdirs
  do
      echo "Creating Terraform Infrastructure in $tfdir"
      pushd $tfdir && ./tf.sh apply dev && popd && sleep 5
      echo "Sleeping..."
  done
}

destroy(){
  for tfdir in $(reverse $tfdirs)
  do
      echo "Destroying Terraform Infrastructure in $tfdir"
      pushd $tfdir && ./tf.sh destroy dev && popd && sleep 5
      echo "Sleeping..."

  done
}

tests(){
    deviceid=$1
    file=$2

    echo "***RUNNING TESTS***"
    if [ -z "$file" ]; then
      echo "File option (-f) not set! Downloading image file to use for testing"
      curl "https://images.unsplash.com/photo-1641679644331-0b52e184c0f0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2580&q=80" > image.png
      file=image.png
    fi

    if [ -z "$deviceid" ]; then
      echo "File option (-i) not set! Will set a random Device ID"
      deviceid=$RANDOM
    fi

    echo "Testing PUT Request to $url/devices/$deviceid"
    curl -X PUT -F 'file=@image.png' "$url/devices/$deviceid"

    echo "Testing GET Request to $url/devices/"
    curl -X GET "$url/devices/"

    echo "Testing GET Request to $url/devices/$deviceid"
    curl -X GET "$url/devices/$deviceid" --output $deviceid
    echo  "b64 encoded data outputted to $deviceid"

}

main(){

  ### Argparse ###
  while getopts ":a:i:f:h" option; do
     case $option in
        a)
          action=${OPTARG}
          ;;
        i)
          id=${OPTARG}
          ;;
        f)
          filepath=${OPTARG}
          ;;
        h) # display Help
           Help
           exit;;
       \?) # incorrect option
           echo "Error: Invalid option" >&2
           exit_with_help
           ;;
     esac
  done

#  ### Validation ###
  if [ $OPTIND -eq 1 ]; then echo "No options were passed!" >&2 && exit_with_help; fi

  if [ $action == "create" ]; then
    create
    pushd "appinfra" > /dev/null && url="$(terraform output -json | jq -r '.alb_url.value'):5000/api"  && popd > /dev/null
    until $(curl --output /dev/null --silent --head --fail $url); do
      echo "Waiting for $url to be available"
      sleep 5
    done

    tests "$id" "$filepath"

    echo "Swagger API interface available at $url"

  elif [ $action == "destroy" ]; then
    destroy

    echo "Resources Destroyed!"

  elif [ $action == "test" ]; then
    pushd "appinfra" > /dev/null && url="$(terraform output -json | jq -r '.alb_url.value'):5000/api"  && popd > /dev/null

    tests "$id" "$filepath"

  else
    echo "Option -a should be either create, test or destroy"
    exit_with_help
  fi
}

main "$@"