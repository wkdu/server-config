#!/bin/bash
#
# create-recordings.sh
#
# This is a script that will automatically record a radio audio stream to a .wav file using the arecord program.
#
#   arecord program significant options:
#
#       -r, --rate=#<Hz> Sampling rate in Hertz.
#       -d, --duration=# Interrupt recording after # seconds.
#       -c, --channels=# The number of channels.  The default is one channel.
#
#   Note: Gmail SMTP limited to 500 emails per day.
#
#   Default crontab schedule:
#       "@hourly" or "0 * * * *"
#
#####################################################################################################################################

##  First we determine today's date and set variables $YR, $MO, and $DAY.
##  Also set variable $NOW for current date and time.
YR=$(date +%Y)                                                          ## set variable $YR for year (4 digits)
MO=$(date +%m)                                                          ## set variable $MO for month
DAY=$(date +%d)                                                         ## set variable $DAY for day
NOW=$(date +'%Y/%m/%d %T')                                              ## sets date / time variable $NOW

##  Next we determine the current time and set variables $H and $M.
H=$(date +%H)                                                           ## set variable $H for hour (24 hour)
M=$(date +%M)                                                           ## set variable $M for minute
echo "$NOW Starting recording to audio file $YR-$MO-$DAY-$H$M.mp3"      ## puts start time entry in record.log

## Default external drive location (may need to be updated if the drive name changes)
EXT_DIR="/media/peter/Recordings"

## Create directory for today's recordings
if [ -d ${EXT_DIR} ]; then                                      ## Test to see if external drive directory exists

    ## Check for existing directory for today, if not make one
    if [ ! -d "$EXT_DIR/wkdu/$YR-$MO-$DAY" ]; then              
        echo "$NOW Creating directory in external drive: $EXT_DIR/wkdu/$YR-$MO-$DAY"
        mkdir ${EXT_DIR}"/wkdu/$YR-$MO-$DAY"
    fi

else

    EXT2=$(df -h | grep '/dev/sdc2' | awk '{print $6}')         

     ## Check for a different external drive location since it was unable to find the default
    if [ -d "$EXT2" ]; then
        EXT_DIR=EXT2
        if [ ! -d "$EXT2/wkdu/$YR-$MO-$DAY" ]; then
            echo "$NOW Creating directory in external drive: $EXT2/wkdu/$YR-$MO-$DAY"
            mkdir "$EXT2/wkdu/$YR-$MO-$DAY"
        fi

    ## Still couldn't find external drive, let's check for a folder on the computer's internal drives
    elif [ ! -d "/data/recordings/$YR-$MO-$DAY/" ]; then      
        echo "$NOW Creating directory in internal drive: /data/recordings/$YR-$MO-$DAY/"
        mkdir "/data/recordings/$YR-$MO-$DAY"
    fi

fi

echo "$NOW Audio file: $YR-$MO-$DAY-$H$M.mp3"                           ## puts start time entry in record.log

## Start a 1 hour recording at CD quality (16bit little endian, stereo, 44.1KHz) and pipe to compressed MP3 format
if [ -d ${EXT_DIR} ]; then

    echo "$NOW Starting recording audio file to external drive: $EXT_DIR"

    ## Records audio stream for 60 minutes (3600 seconds)
    arecord -D "plughw:1,0" -d3600 -f cd -t raw -q | lame -r -b 192 - "$EXT_DIR/wkdu/$YR-$MO-$DAY/$YR-$MO-$DAY-$H$M.mp3" -quiet

else

    ## Send out email alert
    echo "$NOW Unable to find external drive during cronjob. Started recording in internal drive instead: /data/recordings/$YR-$MO-$DAY/$YR-$MO-$DAY-$H$M.mp3" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[ALERT] Created new recording in INTERNAL drive" admin@wkdu.org
    echo "$NOW Starting recording audio file to internal drive: /data/recordings (could not find external drive)"

    ## Records audio stream for 60 minutes (3600 seconds)
    arecord -D "plughw:1,0" -d3600 -f cd -t raw -q | lame -r -b 192 - "/data/recordings/$YR-$MO-$DAY/$YR-$MO-$DAY-$H$M.mp3" -quiet
fi

NOW=$(date +'%Y/%m/%d %T')                                              ## resets date / time variable $NOW to current time
echo "$NOW Finished recording audio file: $YR-$MO-$DAY-$H$M.mp3"        ## puts stop recording time entry in record.log
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"  ## puts separation line in record.log

