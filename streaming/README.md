## Streaming Server

The streams can be accessed at [streams.wkdu.org](http://streams.wkdu.org). It sets up an AAC+ stream and an MP3 stream.

| File name | Location on server | Purpose
|----|----|
| main.liq | /home/peter/liquidsoap-daemon/main.liq | Liquidsoap stream setup file
| icecast.xml | /etc/icecast2/icecast.xml | Icecast2 settings
| rc.local | /etc/rc.local | Run liquidsoap daemon on startup

Production-level passwords in setting files have been replaced with ``"hackme"``.
