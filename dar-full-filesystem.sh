#!/bin/bash
# Usage: dar-full-filesystem.sh
# Purpose: Creates a full DAR backup of a defined filesystem/directory
# Last Modified: 28 Sep 25
# latrunculus.occulte@hush.ai
# Variables:
set -euo pipefail
Version="1.1.0"
NOW=$(date +%Y%m%d)
# Location of DAR executable. If DAR is is installed system wide can be substituted with DAREXEC=$(which dar)
DAREXEC="/usr/local/bin/dar"
# Location of mounted filesystem to backup (examples: /, /opt, /boot, /home, /mnt/external/imagedata)
BUTGT=/mnt/int/mappingdata
# Name of backup drive to accomodate for more than one backup drive
BUDRIVE=backup-3
# Name of the backup set
BUNAME=mappingdata
# Modify to reflect path to the backup drive (Example if backup drive is mounted at /mnt/backup then
#   BUPATH="/mnt/$BUDRIVE/$BUNAME")
BUPATH="/mnt/ext/$BUDRIVE/$BUNAME"
# A check file that must exist on the backup drive. If BUDRIVE is set to mybackupdrive (BUDRIVE=mybackupdrive) then
#   mybackupdrive/mybackupdrive.text must exist.
BUDFILE="$BUDRIVE.text"
# Modify to reflect path to the backup drive in the same manner as BUPATH
BUCHK="/mnt/ext/$BUDRIVE/$BUDFILE"
# A check file (default is do_not_delete.text) must exist in the base directory of the file system to be backed up.
#   For example to backup the /opt directory the file /opt/do_not_delete.text must exist. This can be changed
#   to accomadate for filesystems that one cannot, or does not want to, write an additional file to, such as
#   recovery partitions. You could use CHKFILE=="$BUTGT/DELLBIO.BIN" for instance.
CHKFILE="$BUTGT/do_not_delete.text"
# Modify to reflect the path where you want the log files stored.
LOGPATH="/home/public/logs/$NOW"
LOGFILE="errorlog-$BUNAME-$NOW.text"
Help(){
   echo -e "Syntax: $0 -[h|v]"
   echo -e "Options:"
   echo -e "-h   Display Help"
   echo -e "-v   Display Version"
}
Version(){
   echo "Version: $Version"
}
checkFile(){
   if test -e "$CHKFILE"; then
      return 0
   else
      echo "Backup failed. The source volume does not appear to contain the check file." >> "$LOGPATH/$LOGFILE"
      exit 1
   fi
}
checkTarget(){
   if test -e "$CHKFILE"; then
      echo "The backup volume appears to be mounted"
      return 0
   else
      echo "Backup failed. The backup volume does not appear to contain the check file." >> "$LOGPATH/$LOGFILE"
      exit 1
   fi
}
checkDestination(){
   if test -e "$BUPATH"; then
      return 0
   else
      mkdir "$BUPATH"
   fi
}
darBackup(){
"$DAREXEC" -c "$BUPATH/$BUNAME-full" -s 654M -S 640M  -w -va -D  -M -R "$BUTGT" -an   -X "*.tmp" -X "*.temp" -X "*.cache" -X ".lock" -X ".swp" -P "tmp" -P "SteamLibrary" -P "lost+found"
# for root directory add -P "proc" -P "sys" -P "dev" -P "media" -P "mnt"  -P "run"
echo -e "DAR exited with $?"  >> "$LOGPATH/$LOGFILE"
}
trap - SIGTERM SIGINT SIGQUIT SIGTSTP
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
if [[ ! -d "$LOGPATH/$NOW" ]]; then
   mkdir "$LOGPATH/$NOW"
fi
LOGPATH="$LOGPATH/$NOW"
touch "$LOGPATH/$LOGFILE"
checkFile
checkTarget
checkDestination
darBackup
