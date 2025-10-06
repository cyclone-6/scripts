#!/bin/bash
# Usage: imgresizer.sh -W -H -t -p -[h|v]
# Purpose:Batch resizes png or jpg files in a given directory
# Examples:imgresizer.sh -W 1024 -H 788 -t png -p /home/user/images
# Last Modified: 23 Sep 25
# latrunculus.occulte@hush.ai
Version="1.0.0"
inputPath="$PWD"
usage="Syntax: imgresizer.sh -W -H -t -p"
Help(){
   echo -e "Syntax: imgresizer.sh -W -H -t -p -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help."
   echo -e "-v   Display Version."
   echo -e "-W   Minimum image width."
   echo -e "-H   Minimum image height."
   echo -e "-t   Image types to convert (jpg,png)."
   echo -e "-p   The source path of the image files. if a path is not\n     entered, or does not exist, the current working\n     directory is used."
}
Version(){
   echo "Version: $Version"
}
checkMagick(){
   if command -v convert &>/dev/null; then
     return 0
   else
     echo -e "This program requires that the ImageMagick package is installed and convert is in the PATH"  >&2
     exit 1
   fi
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && Help >&2 && exit 1
while getopts ":hvW:H:t:p:" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
      W) width=${OPTARG};;
      H) height=${OPTARG};;
      t) if [[ ${OPTARG} == "png" ]]; then
            fileType="png"
         elif [[ ${OPTARG} == "jpg" ]]; then
            fileType="jpg"
         else
            echo -e "Valid file types are png and jpg"
            exit 1
         fi
         ;;
      p) if [[ ! -d "${OPTARG}" ]]; then
            inputPath="."
         else [[ -d "${OPTARG}" ]]
            inputPath="${OPTARG}"
         fi
         ;;
     \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
if [ -z "$width" ]; then
  echo -e "A width is required\n$usage" >&2
  exit 1
fi
if [ -z "$height" ]; then
  echo -e "A height is required\n$usage" >&2
  exit 1
fi
if [ -z "$fileType" ]; then
  echo -e "A file type selection is required\n$usage" >&2
  exit 1
fi
checkMagick
find $inputPath -maxdepth 1 -type f -iname "*.${fileType}" -exec convert {} -verbose -resize $widthx$height {} \;
