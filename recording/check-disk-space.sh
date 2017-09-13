#!/bin/sh  
#
# check-disk-space.sh
#
# This is a script that will check how much disk space is left and send an email alert notification if near capacity.
#
#   Note: Gmail SMTP limited to 500 emails per day.
#
#####################################################################################################################################

YR=$(date +%Y)                                                           ## set variable $YR for year (4 digits)
MO=$(date +%m)                                                           ## set variable $MO for month
DAY=$(date +%d)                                                          ## set variable $DAY for day
NOW=$(date +'%Y/%m/%d %T')                                               ## sets date / time variable $NOW

EXT_FS="/dev/sdc2"                  ## Filesystem name for external hard drive

REM_30D_192=62265500                ## ~30 days of free space left with 192kbps recordings (in kilobytes)
REM_7D_192=14528617                 ## ~7 days of free space left with 192kbps recordings (in kilobytes)

#REM_30D_320=103775861              ## ~30 days of free space left with 320kbps recordings (in kilobytes)
#REM_7D_320=24214368                ## ~7 days of free space left with 320kbps recordings (in kilobytes)

REM_30D=$REM_30D_192
REM_7D=$REM_7D_192

## Check external drive
if [ -d ${EXT_FS} ]; then
    EXT_FREE=`df -k --output=avail $EXT_FS | tail -n1`

    ## Compare current free space amount in external drive to calculated remaining disk space for 7 days of 192kbps recordings
    if (( echo "$EXT_FREE < $REM_7D" | bc )); then

        ## Log message
        echo $NOW "[DISK CHECK]: Less than 7 days free space remaining in $EXT_FS: $EXT_FREE KB remaining"

        ## Email alert notification
        echo $NOW "Less than 7 days free space of 192kbps recordings remaining in $EXT_FS: $EXT_FREE KB remaining" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[WARNING] Less than 7 days free space available in EXTERNAL drive" admin@wkdu.org

    else if (( echo "$EXT_FREE < $REM_30D" | bc )); then

        echo $NOW "[DISK CHECK]: Less than 30 days free space remaining in $EXT_FS: $EXT_FREE KB remaining"
        echo $NOW "Less than 30 days free space of 320kbps recordings remaining in $EXT_FS: $EXT_FREE KB remaining" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[WARNING] Less than 30 days free space available in EXTERNAL drive" admin@wkdu.org

    fi
fi

## Check /data/ partition
if [ -d /data/ ]; then
    DATA_FREE=`df -k --output=avail /data/ | tail -n1`

    ## Compare current free space amount in internal drive partition to calculated remaining disk space for 7 days of 192kbps recordings
    if (( echo "$DATA_FREE < $REM_7D" | bc )); then

        ## Log message
        echo $NOW "[DISK CHECK]: Less than 7 days free space remaining in /data/: $DATA_FREE KB remaining"

        ## Email alert notification
        echo $NOW "Less than 7 days free space of 192kbps recordings remaining in /data/: $DATA_FREE KB remaining" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[WARNING] Less than 7 days free space available in INTERNAL drive partition /data/" admin@wkdu.org

    else if (( echo "$DATA_FREE < $REM_30D" | bc )); then

        echo $NOW "[DISK CHECK]: Less than 30 days free space remaining in /data/: $DATA_FREE KB remaining"
        echo $NOW "Less than 30 days free space of 320kbps recordings remaining in /data/: $DATA_FREE KB remaining" | mail -a "From: Recordings Server <recordings@wkdu.org>" -s "[WARNING] Less than 30 days free space available in INTERNAL drive partition /data/" admin@wkdu.org

    fi
fi