## Recordings Server

Audio recordings can be accessed at [recordings.wkdu.org](http://recordings.wkdu.org). By default, these files are recorded as 192kbps CBR MP3 files.

On the server, the files are located at `/media/peter/Recordings/wkdu` mounted on `/dev/sdc2`.

| File name | Location on server | Purpose | Crontab scheduling |
| --------- | ------------------ | ------- | ------------------ |
| create-directory.sh | /home/peter/bin/ | Create directory for recordings each day on the external drive (or internal drive if unable to find external drive) | `"0 0 * * *"` (daily) |
| create-recording.sh | /home/peter/bin/ | Create recordings on the external drive (or internal drive if unable to find external drive) by recording audio from the AudioBox USB | `"0 * * * *"` (hourly) |
| continue-recording.sh | /home/peter/bin/ | Similar to `create-recording.sh` except it calculates how long until the end of the hour and creates a recording of that duration (in case server unexpectedly restarts) | (on reboot) |
| check-disk-space.sh | /home/peter/bin/ | Check disk space where recordings are stored and send an email notification if there is low disk space (at 7 and 30 days of recordings left) | `"1 0 * * *"` (daily) |
| .asoundrc | /home/peter/ | ALSA sound config (sets up Audiobox USB audio device to record, uses `plug` chained with `dsnoop` to be able to record from the same device simultaneously) | n/a |
| recordings.wkdu.org | /etc/nginx/sites-available/ | Nginx configuration for recordings.wkdu.org URL | n/a |

### Crontab settings (production)

    # m h d m w     command
      0 0 * * *     /bin/bash /home/peter/bin/create-directory.sh >> /home/peter/log/recordings/create.log 2>&1
      0 * * * *     /bin/bash /home/peter/bin/create-recording.sh >> /home/peter/log/recordings/create.log 2>&1
      1 0 * * *     /bin/bash /home/peter/bin/check-disk-space.sh >> /home/peter/log/recordings/check-disk.log 2>&1
      @reboot       /bin/bash /home/peter/bin/contine-recording.sh >> /home/peter/log/recordings/create.log 2>&1

### Server administrative details

* SSH password authentication and root access is disabled.
* `wkdu` is a non-sudo user on the recordings server. SSH access is disabled for this user.
* [Nginx](http://nginx.org/en/docs/http/ngx_http_autoindex_module.html) is installed so all computers can access recordings remotely by visiting recordings.wkdu.org.
* [Netatalk](http://netatalk.sourceforge.net/) is configured to allow Apple computers (iMacs) at the station to connect directly to the recordings server via the Apple Filing Protocol (AFP).
