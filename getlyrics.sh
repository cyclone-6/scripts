#!/bin/bash
# Usage: getlyrics.sh -s Song -a Artist -[v|h]
# Purpose: Pulls song lyrics from https://api.lyrics.ovh
# Examples:getlyrics.sh -s Hush -a "Deep Purple"
# Last Modified:  18 Sep 25
# latrunculus.occulte@hush.ai
set -euo pipefail
version="0.9.0"
curlGet="curl -A curl -s"
apiURL="https://api.lyrics.ovh/v1/"
Help(){
   echo -e "Syntax: name.sh -[h|v] -a Artist -s Song"
   echo -e "Options:"
   echo -e "h	Display Help"
   echo -e "v   Display Version"
}
Version(){
   echo -e "Version: $version"
}
checkCurl(){
   if  command -v curl &>/dev/null; then
     return 0
   else
     echo -e "The curl program must be installed for this program to run properly.\nEnsure that curl is installed and in the PATH environment variable." >&2
     exit 1
   fi
}
checkInterwebs(){
   ping -c 1 google.com >/dev/null 2>&1
   if [ $? -eq 0 ]; then
     return 0
   else
     echo -e "No internet connection detected.\n This program uses an external web database."
     exit 1
   fi
}
encodeArtist(){
   artist=$(echo ${OPTARG} | sed s/" "/%20/g | sed s/"!"/%21/g | sed s/"&"/%26/g | sed s/","/%2C/g | sed s/"-"/%2D/g | sed s/"?"/%3F/g)
}
encodeSong(){
   song=$(echo ${OPTARG} | sed s/" "/%20/g | sed s/"!"/%21/g | sed s/"&"/%26/g | sed s/","/%2C/g | sed s/"-"/%2D/g | sed s/"?"/%3F/g)
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: name.sh \$1" >&2 && exit 1
while getopts "hva:s:" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
      a) encodeArtist;;
      s) encodeSong;;
     \?) echo -e "Error! You have entered an invalid option."
         exit 1;;
   esac
done
checkCurl
checkInterwebs
fetchedLyrics=$($curlGet "$apiURL$artist/$song")
if [[ $(echo "$fetchedLyrics" | cut -f 2 -d \") == "error" ]]; then
   { echo -e "Sorry, no lyrics found."; exit 1; }
fi
echo -e "$fetchedLyrics" | sed s/"{\"lyrics\":\""/""/g | sed s/"\"}"/""/g
