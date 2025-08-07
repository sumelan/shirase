{pkgs, ...}: let
  mkFormat = height: ''"bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'';
in {
  programs = {
    yt-dlp = {
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
  };

  # yt-dlp’s dependencies
  home.packages = with pkgs; [
    # Required
    ffmpeg
    # For --embed-thumbnail in certain formats
    (python313.withPackages (ps: with ps; [mutagen]))
  ];
}
