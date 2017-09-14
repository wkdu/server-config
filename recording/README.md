## Recordings Server

Audio recordings can be accessed at [recordings.wkdu.org](http://recordings.wkdu.org). By default, these files are recorded as 192kbps CBR MP3 files.

| File name | Location on server | Purpose | Crontab scheduling
| --------- | ------------------ | ------- |
| create-recordings.sh | /home/peter/bin/ | Create recordings on the external drive (or internal drive if unable to find external drive) by recording audio from the AudioBox USB | "0 * * * *" or "@hourly" |
| check-disk-space.sh | /home/peter/bin/ | Check disk space where recordings are stored and send an email notification if there is low disk space (at 7 and 30 days of recordings left) | "0 0 * * * " or "@daily" |

