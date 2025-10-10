#!/bin/bash
# Usage: nero2iso.sh source.nrg output.iso
# Purpose:Converts a nero .nrg file to an .iso file
# Examples:nero2iso.sh gamedisc.nrg gamedisc.iso
# Last Modified:10 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="1.0.0"
Help(){
   echo -e "Syntax: $0 source.nrg output.iso $-[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
checkNRG(){
   if [[ $(file "$neroFile" | cut -f 2 -d " ") = "Nero" ]]; then
      return 0
   else
      echo "$neroFile does not appear to be a Nero NRG file" >&2
      exit 1
   fi
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 2 ] && echo -e "Usage: $0 source.nrg output.iso" >&2 && exit 1
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
neroFile=$1
isoFile=$2
checkNRG
dd bs=1k if="$neroFile" of="$isoFile" skip=300
exit 0

