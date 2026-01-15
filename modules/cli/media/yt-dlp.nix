_: let
  inherit (builtins) toString;
  mkFormat = height: ''"bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'';
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    programs.yt-dlp = {
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
    home.packages = [
      # must
      pkgs.ffmpeg
      # `--embed-thumbnail` need this in certain formats
      (pkgs.python313.withPackages
        (ps: [ps.mutagen]))
    ];
  };
}
