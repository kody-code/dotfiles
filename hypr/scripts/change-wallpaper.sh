#!/bin/sh
WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
CACHE_FILE="$HOME/.cache/current_wallpaper"

# 确保目录存在
mkdir -p "$(dirname "$CACHE_FILE")" 2>/dev/null
[ -d "$WALLPAPER_DIR" ] || mkdir -p "$WALLPAPER_DIR"

NEXT_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | shuf -n1)

if [ -z "$NEXT_WALLPAPER" ]; then
    echo "⚠️ 未找到壁纸文件，请添加图片到: $WALLPAPER_DIR"
    exit 1
fi

# 初始化 awww (如果未运行)
if ! pgrep -x awww-daemon >/dev/null; then
    awww-daemon
fi

# 平滑切换壁纸 - 与 swww 完全兼容的命令
awww img "$NEXT_WALLPAPER" \
    --transition-type=wipe \
    --transition-duration=1.5 \
    --transition-fps=60 \
    --transition-angle=30 \
    --transition-bezier=.43,1.19,1,.4

# 保存当前壁纸
echo "$NEXT_WALLPAPER" > "$CACHE_FILE"
echo "✅ 壁纸已切换: $(basename "$NEXT_WALLPAPER")"
