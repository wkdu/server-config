## Streaming Server

The streams can be accessed at [streams.wkdu.org](http://streams.wkdu.org). These files below set up a 128kbps AAC stream and a 128kbps MP3 stream.

| File name | Location on server | Purpose |
| --------- | ------------------ | ------- |
| `main.liq` | /home/peter/liquidsoap-daemon/script/ | Liquidsoap stream setup file |
| `icecast.xml` | /etc/icecast2/ | Icecast2 settings |
| `icecast2` | /etc/default/ | Icecast2 defaults (run as root to listen on port 80) |
| `rc.local` | /etc/ | Run liquidsoap daemon automatically on server startup |

Production-level passwords in setting files have been replaced with ``"hackme"``.
