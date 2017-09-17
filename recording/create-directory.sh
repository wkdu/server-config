#!/bin/bash
#
# create-directory.sh
#
# This is a script that will automatically create a new directory/folder for a given day's recordings.
#
#
#   Note: Gmail SMTP limited to 500 emails per day.
#
#   Default crontab schedule:
#       "@daily" or "0 0 * * *"
#
#####################################################################################################################################

##  First we determine today's date and set variables $YR, $MO, and $DAY.
##  Also set variable $NOW for current date and time.
YR=$(date +%Y)                                                          ## set variable $YR for year (4 digits)
MO=$(date +%m)                                                          ## set variable $MO for month
DAY=$(date +%d)                                                         ## set variable $DAY for day
NOW=$(date +'%Y/%m/%d %T')                                              ## sets date / time variable $NOW

## Default external drive location (this may need to be updated if the drive name changes)
EXT_DIR="/media/peter/Recordings"

## Test to see if external drive directory exists
if [ -d "$EXT_DIR" ]; then

    ## Check for existing directory for today, if not make one
    if [ ! -d "$EXT_DIR/wkdu/$YR-$MO-$DAY" ]; then              

        ## put separation line in create-recording.log
        echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

        echo "$NOW Created directory in external drive: $EXT_DIR/wkdu/$YR-$MO-$DAY"
        mkdir ${EXT_DIR}"/wkdu/$YR-$MO-$DAY"

    fi

else

    EXT2=$(df -h | grep '/dev/sdc2' | awk '{print $6}')

     ## Check for a different external drive location since it was unable to find the default
    if [ -d "$EXT2" ]; then
        EXT_DIR=EXT2
        if [ ! -d "$EXT2/wkdu/$YR-$MO-$DAY" ]; then

            ## put separation line in create-recording.log
            echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

            echo "$NOW Created directory in external drive: $EXT2/wkdu/$YR-$MO-$DAY"
            mkdir "$EXT2/wkdu/$YR-$MO-$DAY"

        fi

    ## Still couldn't find external drive, let's check for a folder on the computer's internal drives
    elif [ ! -d "/data/recordings/$YR-$MO-$DAY/" ]; then

        ## Send out email alert
        echo "$NOW Unable to find external drive during create-directory cronjob. Created directory in internal drive instead: /data/recordings/$YR-$MO-$DAY" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[ALERT] Created new directory in INTERNAL drive" admin@wkdu.org

        ## put separation line in create-recording.log
        echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

        echo "$NOW Created directory in internal drive: /data/recordings/$YR-$MO-$DAY/"
        mkdir "/data/recordings/$YR-$MO-$DAY"

    fi

fi
