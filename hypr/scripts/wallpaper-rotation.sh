#!/bin/bash

WALLDIR="$HOME/Picture/wallpapers"
CACHE="$HOME/.cache/current_wallpaper"

while true; do
  # 获取所有壁纸
  wallpapers=($(find "$WALLDIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \)))

  # 随机选择(不重复)
  if [ -f "$CACHE" ]; then
    last_wallpaper=$(cat "$CACHE")
    # 过滤掉上一张壁纸
    new_wallpapers=()
    for wp in "${wallpapers[@]}"; do
      if [ "$wp" != "$last_wallpaper" ]; then
        new_wallpapers+=("$wp")
      fi
    done
    wallpaper="${new_wallpapers[RANDOM % ${#new_wallpapers[@]}]}"
  else
    wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"
  fi

  # 应用壁纸，带淡入效果
  swww img "$wallpaper" --transition-type=wipe --transition-fps=30 --transition-duration=1

  # 保存当前壁纸
  echo "$wallpaper" >"$CACHE"

  # 等待5分钟
  sleep 3m
done
