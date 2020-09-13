## Recordings Server

Audio recordings can be accessed at [recordings.wkdu.org](http://recordings.wkdu.org). By default, these files are recorded as 192kbps CBR MP3 files. Depending on the time of day, some files are recorded as 320kbps CBR MP3 files.

On the server, the audio recordings are located at `/media/wkdu/Recordings/wkdu` mounted on `/dev/sdc1`.

| File name | Location on server | Purpose | Default crontab scheduling |
| --------- | ------------------ | ------- | ------------------ |
| `create-directory.sh` | /home/wkdu/bin/ | Create directory for the next day of recordings on the external drive (or internal drive if unable to find external drive) | `"59 23 * * *"` (daily at 11:59PM) |
| `create-recording-192.sh` | /home/wkdu/bin/ | Create 192kbps recordings on the external drive (or internal drive if unable to find external drive) by recording audio from the AudioBox USB | `"0 1-11 * * *"` (hourly between 1-11AM) |
| `create-recording-320.sh` | /home/wkdu/bin/ | Create 320kbps recordings on the external drive (or internal drive if unable to find external drive) by recording audio from the AudioBox USB | `"0 12-23 * * *"` (hourly between 12-11PM) |
| `continue-recording.sh` | /home/wkdu/bin/ | Similar to `create-recording.sh` except it calculates how long until the end of the hour and creates a recording of that duration (in case server unexpectedly restarts) | (on reboot) |
| `check-disk-space.sh` | /home/wkdu/bin/ | Check disk space where recordings are stored and send an email notification if there is low disk space (at 7 and 30 days of recordings left) | `"1 0 * * *"` (daily) |
| `.asoundrc` | /home/wkdu/ | ALSA sound config (sets up Audiobox USB audio device to record, uses `plug` chained with `dsnoop` to be able to record from the same device simultaneously) | n/a |
| `recordings.wkdu.org` | /etc/nginx/sites-available/ | Nginx configuration for recordings.wkdu.org URL | n/a |

### Crontab settings (production)

    # m h  dom mon dow   command
      59 23 * * *     /bin/bash /home/wkdu/bin/create-directory.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/create-error.log
      0 0 * * *     /bin/bash /home/wkdu/bin/create-recording-320.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/create-error.log
      0 1-11 * * *     /bin/bash /home/wkdu/bin/create-recording-192.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/create-error.log
      0 12-23 * * *     /bin/bash /home/wkdu/bin/create-recording-320.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/create-error.log
      1 0 * * *     /bin/bash /home/wkdu/bin/check-disk-space.sh >> /home/wkdu/log/recordings/check-disk.log 2>&1
      @reboot       /bin/sleep 85  && /bin/bash /home/wkdu/bin/create-directory.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/create-error.log
      @reboot       /bin/sleep 100 && /bin/bash /home/wkdu/bin/continue-recording.sh >> /home/wkdu/log/recordings/create.log 2>/home/wkdu/log/recordings/continue-error.log


### Server administrative details

* SSH password authentication and root access is disabled.
* [Nginx](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html) is installed so all computers can access recordings remotely by visiting recordings.wkdu.org.
* [Netatalk](http://netatalk.sourceforge.net/) is configured to allow Apple computers (iMacs) at the station to connect directly to the recordings server via the Apple Filing Protocol (AFP).
* Recordings are delayed 100 seconds after reboot to allow time for USB devices (AudioBox USB, and external hard drives) to properly mount.
