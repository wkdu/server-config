## Streaming Server

The streams can be accessed at [streams.wkdu.org](http://streams.wkdu.org). These files below set up an AAC+ stream and an MP3 stream.

| File name | Location on server | Purpose |
| --------- | ------------------ | ------- |
| main.liq | /home/peter/liquidsoap-daemon/main.liq | Liquidsoap stream setup file |
| icecast.xml | /etc/icecast2/icecast.xml | Icecast2 settings |
| rc.local | /etc/rc.local | Run liquidsoap daemon automatically on server startup |

Production-level passwords in setting files have been replaced with ``"hackme"``.
