#!/bin/sh  
#
# create-recordings.sh
#
# This is a script that will automatically record a radio audio stream to a .wav file using the arecord program.
#
#   arecord program significant options:
#
#   -r, --rate=#<Hz> Sampling rate in Hertz.
#
#   -d, --duration=# Interrupt recording after # seconds. 
#
#   -c, --channels=# The number of channels.  The default is one channel.
#
#####################################################################################################################################

#  First we determine today's date and set variables $YR, $MO, and $DAY.  Also set variable $NOW for current date and time. 
YR=$(date +%Y)                                                           # set variable $YR for year (4 digits)
MO=$(date +%m)                                                           # set variable $MO for month
DAY=$(date +%d)                                                          # set variable $DAY for day
NOW=$(date +'%Y/%m/%d %T')                                               # sets date / time variable $NOW

#  Next we determine the current time and set variables $H and $M.
H=$(date +%H)                                                            # set variable $H for hour (24 hour)
M=$(date +%M)                                                            # set variable $M for minute
echo $NOW "Starting recording to audio file "$YR-$MO-$DAY-$H$M".mp3"     # puts start time entry in record.log

EXT_DIR="/media/peter/Recordings"

if [ -d ${EXT_DIR} ]; then
    # 

    # Create directory for today's recordings
    if [ ! -d "$EXT_DIR/wkdu/$YR-$MO-$DAY" ]; then
        mkdir ${EXT_DIR}/wkdu/$YR-$MO-$DAY
    fi
else
    if [ ! -d "/data/recordings/$YR-$MO-$DAY/"]; then
        mkdir /data/recordings/$YR-$MO-$DAY
    fi
fi

# Start 1 hour recording at CD quality (16bit little endian, stereo, 44.1KHz) and pipe to compressed MP3 format

if [ -d ${EXT_DIR} ]; then
    FREE=`df -k --output=avail $EXT_DIR | tail -n1`
    arecord -D "plughw:1,0" -d3600 -f cd -t raw | lame -r -b 256 - ${EXT_DIR}/wkdu/$YR-$MO-$DAY/$YR-$MO-$DAY-$H$M.mp3             # Records audio stream for 60 minutes (3600 seconds)
else
    FREE=`df -k --output=avail /data/ | tail -n1`
    echo $NOW "[ERROR] Could not find $EXT_DIR, recording file to /data/recordings instead"
    arecord -D "plughw:1,0" -d3600 -f cd -t raw | lame -r -b 256 - /data/recordings/$YR-$MO-$DAY/$YR-$MO-$DAY-$H$M.mp3              # Records audio stream for 60 minutes (3600 seconds)
fi

NOW=$(date +'%Y/%m/%d %T')                                               # resets date / time variable $NOW to current time
echo $NOW "Finished recording "$YR-$MO-$DAY-$H$M".mp3"               # puts stop recording time entry in record.log
echo
ls -l /${HOME}/radio/recordings/$YR-$MO-$DAY-$H$M.mp3              # lists output file size and details
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"  # puts separation line in record.log
                
