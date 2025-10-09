#!/bin/bash
# Usage: genSOI.sh -y year -d dictfile
# Purpose: Populates a yearly paper SOI authentication set
# Examples: genSOI.sh -d lg_eng_words.text -y 2026
# Last Modified:08 Oct 25
# latrunculus.occulte@hush@hush.ai
set -euo pipefail
Version="1.0.0"
year=""
dictFile=""
AllWords=()
RandomWords=()
YearDates=()
AllKeys=()
pause(){
read -p "Pause" getEnterKey
}
Help(){
   echo -e "Syntax: $0 -y year -d dictfile -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
   echo -e "-y   Year (defaults to current year)"
   echo -e "-d   Dictionary File"
}
Version(){
   echo "Version: $Version"
}
checkLeap(){
   if (( year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) )); then
      yearDays=366
   else
      yearDays=365
   fi
}
popAllWords(){
   grep -P -q '^(?!.*([a-z]).*\1)[a-z]{10}$' "$dictFile"
   if [ $? -eq 0 ]; then
      AllWords+=( $(grep -P '^(?!.*([a-z]).*\1)[a-z]{10}$' "$dictFile") )
   fi
   numWords="${#AllWords[@]}"
   if [[ "$numWords" -lt 366 ]]; then
      echo -e "There are not enough 10 letter words for a full year in your dictionary list"
      exit 1
   fi
}
popRandom(){
   for (( d=0; d<="$((yearDays-1))"; d++ ))
      do
         randomNumber=$(( ( $(od -An -N2 -d /dev/urandom) % "$numWords" ) + 1 ))
         RandomWords+=( ${AllWords["$randomNumber"]} )
         for element in ${AllWords["$randomNumber"]}; do
            AllWords=(${AllWords[@]/"$element"})
            numWords=$((numWords - 1))
         done
      done
}
popDays(){
   for (( doy=1; doy<="$yearDays"; doy++ ))
      do
          newDate=$(date -d "$year-01-01 +$((doy - 1)) days" +"%b %d, %Y")
          YearDates+=( "$newDate" )
      done
}
popKeys(){
   for (( k=1; k<="$yearDays"; k++ ))
      do
         AllKeys+=( $(shuf -z -i 0-9 | tr -d '\0') )
      done
}
createSOI(){
for (( soiDays=0; soiDays<="$(($yearDays-1))"; soiDays++ ))
   do
      sepWord="${RandomWords[$soiDays]}"
      sepNumber="${AllKeys[$soiDays]}"
      unset charOut
      unset numOut
      echo "Day $((soiDays+1)):  ${YearDates[$soiDays]}"
      for (( sep=0; sep<=9; sep++ ))
         do
            letter="${sepWord:sep:1}"
            charOut+="$letter"
            if [[ "$sep" -lt $((${#sepWord}-1)) ]]; then
               charOut+=" | "
            fi
         done
      for item in "${charOut[@]}"
         do
            echo "$item"
         done
      echo -e "--|---|---|---|---|---|---|---|---|---"
      for (( sep2=0; sep2<=9; sep2++ ))
         do
            number="${sepNumber:sep2:1}"
            numOut+="$number"
            if [[ "$sep2" -lt $((${#sepNumber}-1)) ]]; then
               numOut+=" | "
            fi
         done
      for item in "${numOut[@]}"
         do
            echo "$item"
         done
   echo
   done
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: $0 dictfile" >&2 && exit 1
while getopts ":hvy:d:" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
      y) year=${OPTARG};;
      d) dictFile=${OPTARG};;
     \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
if [[ "$year" == "" ]]; then
   year=$(date +%Y)
fi
if [[ "$dictFile" == "" ]]; then
   echo -e "Usage: $0 dictfile" >&2 && exit 1
fi
checkLeap
popAllWords
popRandom
popDays
popKeys
createSOI
exit 0
