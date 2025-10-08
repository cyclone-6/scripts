#!/bin/bash
# Usage: mkwordlists.sh $1
# Purpose: Generates length specific word lists from a dictionary file
# Examples: ./mkwordlists.sh lg_eng_words.text
# Last Modified:08 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="1.0.0"
# Minimum word length list
min=4
# Maximum word length list
max=25
Help(){
   echo -e "Syntax: $0 dictfile -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: $0 dictfile" >&2 && exit 1
while getopts "hv" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
     \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
dict_file=$1
for (( i="$min"; i<="$max"; i++ ))
   do
      grep -E -q "^[[:alpha:]]{$i}$" "$dict_file"
      if [ $? -eq 0 ]; then
         if [[ i -lt 10 ]]; then
            grep -E "^[[:alpha:]]{$i}$" "$dict_file" > "0$i-letter-words.text"
            echo -e "0$i Letter Words List Created"
         else
            grep -E "^[[:alpha:]]{$i}$" "$dict_file" > "$i-letter-words.text"
            echo -e "$i Letter Words List Created"
         fi
      fi
   done
