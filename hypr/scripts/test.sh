WALLPAPER_DIR="$HOME/Pictures/Wallpapers/"
NEXT_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \) 2>/dev/null | shuf -n1)
echo "$NEXT_WALLPAPER"
