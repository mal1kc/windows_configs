yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors --extract-audio --audio-format mp3 -o  "./%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" $args[0]
