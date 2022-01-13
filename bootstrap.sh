#!/bin/bash

set -e
set -o pipefail

tfdirs="networking appinfra nlpcicd"


Help(){
   # Display Help
   echo "This script builds out the entire Project, by running all needed Terraform deployments. "
   echo
   echo "Syntax: ./bootstrap.sh [-a|h]"
   echo "options:"
   echo "a     Creates or Destroys the Project. *NOTE* Choices are  (create|destroy)"
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

main(){

  ### Argparse ###
  while getopts ":a:h" option; do
     case $option in
        a)
          action=${OPTARG}
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
#  if [ -z "$secretid" ]; then echo "Missing Option: -i" >&2 && exit_with_help; fi
#  if [ -z "$filealias" ]; then echo "Missing Option: -f" >&2 && exit_with_help; fi
  
  if [ $action == "create" ]; then
    create
    pushd "appinfra" > /dev/null && url="$(terraform output -json | jq -r '.alb_url.value'):5000/api"  && popd > /dev/null
    echo $url
    until $(curl --output /dev/null --silent --head --fail $url); do
      printf 'Waiting for $url to be available'
      sleep 5
    done

    curl "https://www.python.org/static/apple-touch-icon-144x144-precomposed.png" > image.png
    echo "$url/devices/pjndfsdjanpn"
    curl -X PUT -F 'file=@image.png' "$url/devices/pjndfsdjanpn"
    curl -X GET "$url/devices/"
    curl -X GET "$url/devices/pjndfsdjanpn"

  elif [ $action == "destroy" ]; then
    destroy

    echo "Resources Destroyed!"

  else
    echo "Option -a should be either create or destroy"
    exit_with_help
  fi
}

main "$@"