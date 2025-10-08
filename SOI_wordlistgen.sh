#!/bin/bash
# Usage: SOI_wordlistgen.sh wordlist
# Purpose: Generates a list of words from a dictionary word list that does not have more than one instance
#   of any given letter in a word. Most useful when used against a dictionary list of 10 letter words
#   (which can be generated with mkwordlists.sh) to generate a list for a paper Signal Operating Instruction
#   (SOI) authentication set.
# Examples: ./SOI_wordlistgen.sh 10-letter-words.text
# Last Modified: 08 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="1.0.0"
Help(){
   echo -e "Syntax: $0 wordlist -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: $0 wordlist" >&2 && exit 1
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
feederList=$1
grep -P  -q '^(?!.*([a-z]).*\1)[a-z]+$' "$feederList"
if [ $? -eq 0 ]; then
   grep -P '^(?!.*([a-z]).*\1)[a-z]+$' "$feederList" > "SOI-wordlist.text"
   echo -e "SOI word list of $(cat SOI-wordlist.text | wc -l) words created"
else
   echo -e "No words in the feeder list meet the criteria.\nNo SOI list created."
fi
exit 0
