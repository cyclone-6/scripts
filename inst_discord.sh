#!/bin/bash
# Usage: name.sh $1
# Licensed under GPL 3.0
# Purpose: Installed latest discord .deb file in a given directory (dwnld_loc)
# Last Modified: 25 Sep 25
# latrunculus.occulte@hush.ai
set -euo pipefail
dwnld_loc="/home/public/discord"
Version="0.5.0"
Help(){
   echo -e "Syntax: $0 -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -gt 0 ] && echo -e "Usage: $0" >&2 && exit 1
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
dver=$(ls "$dwnld_loc" | grep -i discord | cut -f 3 -d . | sort -h | tail -1)
sudo dpkg -i "$dwnld_loc"/discord-0.0.$dver.deb
exit 0
