
function download_music_playlist
{
  param ( $url )
  yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors --extract-audio --audio-format mp3 --embed-metadata -o  "./%(playlist_title)s/%(channel)s - %(title)s.%(ext)s" $url
}

function download_music_album
{
  param (
    $url
  )
  yt-dlp -f "bestaudio" --continue --no-overwrites --ignore-errors --extract-audio --audio-format mp3 --embed-metadata -o "./%(album)s/%(playlist_index)s - %(artist)s - %(track)s.%(ext)s" $url
}
