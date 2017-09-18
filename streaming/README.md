## Streaming Server

The streams can be accessed at [streams.wkdu.org](http://streams.wkdu.org). These files below set up a 64kbps AAC+ stream and a 128kbps MP3 stream.

| File name | Location on server | Purpose |
| --------- | ------------------ | ------- |
| `main.liq` | /home/peter/liquidsoap-daemon/ | Liquidsoap stream setup file |
| `icecast.xml` | /etc/icecast2/ | Icecast2 settings |
| `rc.local` | /etc/ | Run liquidsoap daemon automatically on server startup |
| `streams.wkdu.org` | /etc/nginx/sites-available/ | Nginx configuration for streams.wkdu.org URL

Production-level passwords in setting files have been replaced with ``"hackme"``.
