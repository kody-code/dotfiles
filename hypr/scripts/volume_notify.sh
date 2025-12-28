#!/bin/sh
action=$1
case $action in
  up)
    wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
    ;;
  down)
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    ;;
  toggle)
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    ;;
esac

# 获取并显示音量
vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)
if [ "$muted" -eq 1 ]; then
  notify-send -i audio-volume-muted -r 9991 "音量: 已静音"
else
  icon="audio-volume-low"
  [ "$vol" -gt 33 ] && icon="audio-volume-medium"
  [ "$vol" -gt 66 ] && icon="audio-volume-high"
  notify-send -i $icon -r 9991 "音量: $vol%"
fi
