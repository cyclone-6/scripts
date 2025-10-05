#!/bin/bash
# Usage: metars.sh $1
# Licensed under GPL 3.0
# Purpose: Fetch METARS info from given ICAO
# Examples:metars.sh KBHB
# latrunculus.occulte@hush.ai
# Last Modified:25 Sep 25
Version="0.9.0"
Help(){
   echo -e "Syntax: metars.sh $1 -[h|v] \$1"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
validateICAO(){
   inputString=$1
   if [[ $inputString  =~ [a-zA-Z]{4} ]]; then
      ICAO=$(echo $inputString | sed 's/[a-z]/\U&/g')
      return 0
   else
      echo -e "Input does not appear to use a valid ICAO code"
      exit 1
   fi
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -ne 1 ] && echo -e "Usage: metars.sh \$1" >&2 && exit 1
validateICAO $1
while getopts ":hv" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
     \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
echo $(curl -s ftp://tgftp.nws.noaa.gov/data/observations/metar/stations/$ICAO.TXT)
