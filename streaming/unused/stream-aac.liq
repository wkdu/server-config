#!/usr/bin/liquidsoap -v
output.icecast(%fdkaac(channels=2, samplerate=44100, bitrate=64, afterburner=false, aot="mpeg2_he_aac_v2", transmux="adts", sbr_mode=false),
  host = "streams.wkdu.org",
  port = 8000, password = "hackme",
  mount = "stream.aac",
  input.alsa(device="plughw:1,0"))
