#!/bin/bash
# Usage: javaarray.sh $1
# Licensed under GPL 3.0
# Purpose Load a Jar file with a specific installed java version
#   using array generated list
# latrunculus.occulte@hush.ai
# Last Modified 20 Sep 2025
# jvmpath is location where java virtual machines are installed
jvmpath="/home/cyclone6/jvm"
show_java(){
echo "Default Java Version is:"
echo "$(which java)"
echo "$(/usr/bin/java -version)"
declare -i entry=0
cd $jvmpath
for filename in *
  do
    if [ -f $filename/bin/java ]
      then ARRAY+=( $filename )
    fi
  done
for list in "${ARRAY[@]}"
  do
    for item in $list
      do
        echo "$entry.  $list"
      done
      entry=entry+1
    done
cd - > /dev/null
}
show_choice(){
echo "Choose Java Version to Run with Jar File $1"
declare -i getChoice
declare -i num_entry=${#ARRAY[@]}-1
read -p "Enter Number (0-$num_entry):" getChoice
if (( $getChoice > $num_entry ))
  then echo "Invalid Choice" && exit 1
fi
echo "$(~/jvm/${ARRAY[$getChoice]}/bin/java -version)"
$jvmpath/${ARRAY[$getChoice]}/bin/java -jar $1
}

trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -ne 1 ] && echo "No Jar File Specified - Usage: javaarray.sh \$1" >&2 && exit 1
ARRAY=()
show_java ${ARRAY}
show_choice $1 ${ARRAY}
