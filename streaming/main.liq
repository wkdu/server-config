# main.liq

set("log.file",true)
set("log.file.path","/home/peter/liquidsoap-daemon/log/run.log")
set("init.daemon",true)
set("init.daemon.change_user",true)
set("init.daemon.change_user.group","peter")
set("init.daemon.change_user.user","peter")
set("init.daemon.pidfile",true)
set("init.daemon.pidfile.path","/home/peter/liquidsoap-daemon/pid/main-run.pid")

# plughw:1,0 is the AudioBox USB (check audio devices with `aplay -L`)
audiobox=input.alsa(device="plughw:1,0")

############################
#  AAC stream for Icecast2 #
############################

output.icecast(%fdkaac(channels=2, samplerate=48000, bandwidth="auto", bitrate=128, afterburner=false, aot="mpeg4_aac_lc", transmux="adts", sbr_mode=false),
  host = "streams.wkdu.org",
  port = 80, password = "hackme",
  mount = "listen.aac",
  audiobox)

############################
#  MP3 stream for Icecast2 #
############################

output.icecast(%mp3(bitrate=128),
  host = "streams.wkdu.org",
  port = 80, password = "hackme",
  mount = "listen.mp3",
  audiobox)

############################
# AAC+ stream for Icecast2 #
############################

#output.icecast(%fdkaac(channels=2, samplerate=48000, bandwidth="auto", bitrate=56, afterburner=true, aot="mpeg4_he_aac_v2", transmux="adts", sbr_mode=true),
#  host = "streams.wkdu.org",
#  port = 80, password = "hackme",
#  mount = "listen.aacplus",
#  audiobox)