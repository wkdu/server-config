#!/usr/bin/liquidsoap -v
output.icecast(%mp3(bitrate=128),
  host = "streams.wkdu.org",
  port = 8000, password = "hackme",
  mount = "stream.mp3",
  input.alsa(device="plughw:1,0"))
