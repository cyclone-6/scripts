#!/bin/bash
# Usage: rm_hist.sh $1
# Purpose:
# Examples:
# Last Modified: 06 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="0.9.0"
Help(){
   echo -e "Syntax: $0 -[h|v] \$1"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: $0 \$1" >&2 && exit 1
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
if [[ -f /home/$USER/.bash_history ]]; then
   sed -i "/$1/d" /home/$USER/.bash_history
fi
if [[ -f /home/$USER/.zsh_history ]]; then
   sed -i "/$1/d" /home/$USER/.zsh_history
fi
if [[ -f /home/$USER/.history ]]; then
   sed -i "/$1/d" /home/$USER/.history
fi
if [[ -f /home/$USER/.sh_history ]]; then
   sed -i "/$1/d" /home/$USER/.sh_history
fi
