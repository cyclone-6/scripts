#!/bin/bash
# Usage: wizzodice.sh $1
# Licensed under GPL 3.0
# Purpose: Rolls a number polyhedral dice
# Examples: wizzodice.sh 1d6
#           wizzodice.sh 2d6+1 4d6
#           wizzodice.sh 2d8 1d4 1d20*2 1d100
# Last Modified 20 Sep 2025
# latrunculus.occulte@hush.ai
#Populate Array With Command Line Arguments
pop_array(){
declare -i c=0
for arg in "$@"; do
  ARRAY+=($arg)
  ((c++))
done
}
#Calculate Individual Contents of Array
calc_array(){
declare -i face
declare -i dice
declare -i diceroll
declare adds
declare adjusted
declare rolltotal
declare alltotal=0
for list in "${ARRAY[@]}"
   do
     for item in $list
       do
         if [[ $(sed -n '/[+*/-]/p' <<< "$list") ]]; then
           if [[ $(sed -n '/[+]/p' <<< "$list") ]]; then
           mods="+"
           elif [[ $(sed -n '/[-]/p' <<< "$list") ]]; then
           mods="-"
           elif [[ $(sed -n '/[/]/p' <<< "$list") ]]; then
           mods="/"
           else
           mods="*"
           fi
           rolltotal=0
           dice=$(echo $list | cut -d d -f 1)
           face=$(echo $list | rev | cut -d "$mods" -f2 | rev | cut -d d -f 2)
           adds=$(echo $list | cut -d "$mods" -f2)
           echo "Rolling $list :"
           for (( rolls=1; rolls<=dice; rolls++ ))
              do
                diceroll=$(( ( $RANDOM % face ) + 1 ))
                rolltotal=$(( $rolltotal + $diceroll ))
		echo "$diceroll"
              done
           adjusted=$(( $rolltotal $mods $adds ))
           alltotal=$(( $alltotal + $adjusted ))
           echo "The total of $list is $adjusted"
         else
           rolltotal=0
           dice=$(echo $list | cut -d d -f 1)
           face=$(echo $list | cut -d d -f 2)
           echo "Rolling $list :"
           for (( rolls=1; rolls<=dice; rolls++ ))
              do
                diceroll=$(( ( $RANDOM % face ) + 1 ))
                rolltotal=$(( $rolltotal + $diceroll ))
                echo $diceroll
              done
           echo "The total of $list is $rolltotal"
           alltotal=$(( $alltotal + $rolltotal ))
         fi
       done
     done
echo "The total of all dice added is $alltotal"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: wizzodice.sh \$1 \nExample: wizzodice.sh 4d6   wizzodice.sh 1d6 2d4+2 1d20   wizzodice.sh 1d6+1d10" >&2 && exit 1
ARRAY=()
pop_array $@
calc_array $@
