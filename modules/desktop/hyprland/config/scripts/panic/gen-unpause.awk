/^#/ {
  sec = $0
  next
}

sec ~ /^# Players/ && $1 {
  print "busctl --user call " $1 " /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player Play"
}
