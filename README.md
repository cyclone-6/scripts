# Cyclone-6's Misc (And Probably Mostly Useless) Scripts For Linux Systems

## deck_shuffle.sh:

Bash script that shuffles a deck of cards (with, or without, jokers), deals out a given number of 5 card hands and displays them with Unicode characters representing the four card suits.

## getlyrics.sh

Bash script that retrieves song lyrics from internet to the terminal. Requires curl.

## imgresizer.sh

Bash script that resizes jpg or png images to given dimensions in a specified directory. Requires ImageMagick.

## inst_discord.sh:

Bash script to make it easier to install the constant updates (almost) every time one launches Discord on Linux. Requires that the download location variable be set and then searches for the latest .deb file version and installs it.

## javaarray.sh:

Bash script that searches a directory containing multiple directories each with a separate version of Java and allows a selection of available versions to launch a specific .jar file. Developed to make it easier to launch certain game servers and IDEs that are version picky.

## metars.sh:

Bash script that given a particular ICAO location code, retrieves latest raw METARS data.

## rmhist.sh

Bash script that simultaneously removes searched lines from .history, .bash_history, .zsh_history and .sh_history.

## wizzodice.sh:

Bash script that rolls a number of polyhedral dice and displays the rolls, the sum of each roll by die type and the sum of all the die type. Die rolls allow for modifiers (ie 4d6+2), developed to help in TTRPG and strategic wargames.

## Backup Scripts for DAR

### dar-full-filesystem.sh, dar-fdiff-filesystem.sh and dar-inc-filesystem.sh

Three bash scripts used to automate DAR for backups. Designed to have the initial backup run manually with incremental backups to be run as cron jobs or services under systemctl. The initial backup is created with dar-full-filesystem.sh and creates a backup broken into 650mb chunks. After running the intitial full backup, run the differential backup with dar-fdiff-filesystem.sh to create a reference for future incremental backups. This will put a timestamp on the end of the name of the backup with the current date. Because of this you either have to wait a day to run your first scheduled backup or you can run your first incremental backup immediately by changing the date in the name of the differential backup to the day prior (the differential backup should be small if done immediately after the full backup). You can create multiple backup jobs by renaming a set of scripts for each backup (for example dar-inc-opt.sh, dar-inc-boot.sh, dar-full-srv.sh).

I am sure there are better DAR scripts out there, but these have always worked for me.

The following variables need to be set in each of the three scripts to localize each backup set:

_DAREXEC_ The location of the DAR executable ( or you can set it to _DAREXEC=$(which dar)_ )

_BUTGT_ The location of the filesystem to backup

_BUDRIVE_ The name of the mounted backup drive

_BUNAME_ The name of the backup set

_BUPATH_ The path to _BUDRIVE_

_BUCHK_,_BUDFILE_ A checkfile name and file location

_CHKFILE_ A checkfile on the backup target

_LOGPATH_ Path where log files are to be stored


