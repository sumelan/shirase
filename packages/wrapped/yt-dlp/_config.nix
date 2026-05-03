_: let
  mkFormat = height: "bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best";
in {
  add-metadata = true;
  format = mkFormat 720;
  no-mtime = true;
  output = "%(title)s.%(ext)s";
  sponsorblock-mark = "all";
  windows-filenames = true;
  # youtube causing 403 errors
  # https://github.com/yt-dlp/yt-dlp/issues/15712#issuecomment-3808702603
  # PR: https://github.com/yt-dlp/yt-dlp/pull/15726
  extractor-args = "youtube:player_client=default,-android_sdkless";
}
