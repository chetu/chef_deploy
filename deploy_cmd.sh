#! /bin/bash

if [ $# -ne 1 ]; then
         echo 1>&2 Usage: $0 staging OR production
	 echo "See README for futher Details"
         exit 127

fi

  case "$1" in
	staging) ./chef_deploy.rb config.yml staging
	 ;;
       	production) ./chef_deploy.rb config.yml production
	 ;;
       	*) echo "No such environment found" 
	   exit
         ;;
  esac



