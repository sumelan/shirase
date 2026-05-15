{config, ...}: {
  flake.custom.hjemConfigs.yt-dlp = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) yt-dlp;
    mkFormat = height: "bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best";
  in {
    hj.packages =
      [
        # yt-dlp’s dependencies
        pkgs.ffmpeg
        # `--embed-thumbnail` need this in certain formats
        (pkgs.python313.withPackages (ps: [ps.mutagen]))
      ]
      ++ [yt-dlp];

    environment.shellAliases = {
      yt = "yt-dlp";
      yt1080 = ''yt-dlp --format "${mkFormat 1080}"'';
      ytaudio = "yt-dlp --audio-format mp3 --extract-audio";
      ytsubonly = "yt-dlp --skip-download --write-subs";
      ytplaylist = "yt-dlp --output '%(playlist_index)d - %(title)s.%(ext)s'";
    };
  };
}
