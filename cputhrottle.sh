#!/bin/bash
# Usage: cputhrottle.sh -s option
# Purpose: Set throttling mode on all cpus or show current setting
# Examples: cputhrottle.sh -s performance
# Last Modified:06 Oct 25
# latrunculus.occulte@hush.ai
set -euo pipefail
Version="1.0.0"
showThrottle="false"
Help(){
   echo -e "Syntax: $0 -s option [-d] [-h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
   echo -e "-s   Set Option:"
   echo -e "        performance"
   echo -e "        powersave"
   echo -e "-d   Display Current Throttle Setting"
}
Version(){
   echo "Version: $Version"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
[ "$#" -lt 1 ] && echo -e "Usage: $0 -o option \n       $0 -d" >&2 && exit 1
while getopts ":hvds:" option; do
   case $option in
      h) Help
         exit 0;;
      v) Version
         exit 0;;
      d) showThrottle="true";;
      s) throttleOption=${OPTARG};;
     \?) echo "Error: Invalid option"
         exit 1;;
   esac
done
if [ $showThrottle = "true" ]; then
   cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
   exit 0
else
   echo "$throttleOption" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
fi
