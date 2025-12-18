{pkgs, ...}: let
  inherit (builtins) toString;
in {
  programs.yt-dlp = let
    mkFormat = height: ''"bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'';
  in {
    enable = true;
    package = pkgs.yt-dlp;
    settings = {
      add-metadata = true;
      format = mkFormat 720;
      no-mtime = true;
      output = "%(title)s.%(ext)s";
      sponsorblock-mark = "all";
      windows-filenames = true;
    };
  };

  # yt-dlp’s dependencies
  home.packages = builtins.attrValues {
    # must
    inherit (pkgs) ffmpeg;
    # for --embed-thumbnail option in certain formats
    thumbnailPackage = pkgs.python313.withPackages (ps: [ps.mutagen]);
  };
}
