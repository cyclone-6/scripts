#!/bin/bash
# Usage: deck_shuffle.sh
# Licensed under GPL 3.0
# Purpose: Shuffles a deck (jokers optional) and deals a requested number of 5 card hands
# Last Modified:3 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="0.9.0"
SuitArray=()
FaceArray=()
DeckArray=()
Help(){
   echo -e "Syntax: $0 -[h|v] [-n]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
   echo -e "-n  No Jokers"
}
Version(){
   echo "Version: $Version"
}
createFaceArray(){
   FaceArray+=( "A" )
   for (( num=2; num<11; num++ ))
   do
      FaceArray+=( "$num"  )
   done
   FaceArray+=( "J" )
   FaceArray+=( "Q" )
   FaceArray+=( "K" )
}
createSuitArray(){
   club=$(echo -e "\u2663")
   spade=$(echo -e "\u2660")
   diamond=$(echo -e "\u2666")
   heart=$(echo -e "\u2665")
   SuitArray+=( "$club" )
   SuitArray+=( "$spade" )
   SuitArray+=( "$diamond" )
   SuitArray+=( "$heart" )
}
createDeckArray(){
for suits in "${SuitArray[@]}"
   do
   for cards in "${FaceArray[@]}"
      do
         DeckArray+=( "$cards$suits" )
      done
   done
   if [[ $nj == "false" ]]; then
      DeckArray+=( "Jok" )
      DeckArray+=( "Jok" )
   fi
}
createShuffleArray(){
   ShuffleArray=( $(shuf -e "${DeckArray[@]}" ) )
}
getCardHands(){
   read -n 1 -p "Enter Number of 5 card hands to deal (max 6): " CardHands
   if [[ $CardHands =~ ^[1-6]+$ ]]; then
      echo
      return 0
   else
      echo
      echo -e "You entered an invalid value"
      echo
      getCardHands
   fi
}
dealHands(){
   for (( DealtHands=1; DealtHands<"$CardHands+1"; DealtHands++ ))
   do
      echo -e "Hand Number $DealtHands"
      for (( NextCard=0; NextCard <5; NextCard++ ))
      do
         DealtCard="${ShuffleArray[((5*DealtHands)-5)+NextCard]}"
         echo "$DealtCard" | tr '\n' ' '
      done
      echo
   done
}
seeFullShuffle(){
   echo
   for card in "${ShuffleArray[@]}"
      do
         echo "[$card]" | tr '\n' ' '
      done
   echo
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -gt 1 ] && echo -e "Usage: $0 -[h|v] [-n]" >&2 && exit 1

while getopts ":hvn" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
      n) nj="true";;
      \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
if [[ "$#" -lt 1 ]]; then
   nj="false"
fi
createFaceArray
createSuitArray
createDeckArray
createShuffleArray
getCardHands
dealHands
read -n 1 -p "Do you want to see the deck shuffle? (y/n)" seeShuffle
if [[ $seeShuffle = "y" ]]; then
   seeFullShuffle
else
   echo
   exit 0
fi
echo
