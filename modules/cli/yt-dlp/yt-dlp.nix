_: let
  mkFormat = height: "bestvideo[height<=?${toString height}][ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best";
in {
  flake.wrappers.yt-dlp = {wlib, ...}: {
    imports = [wlib.wrapperModules.yt-dlp];

    settings = import ./_config.nix {};
  };

  flake.modules.nixos.default = {pkgs, ...}: {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) yt-dlp;
      })
    ];

    environment.shellAliases = {
      yt = "yt-dlp";
      yt1080 = ''yt-dlp --format "${mkFormat 1080}"'';
      ytaudio = "yt-dlp --audio-format mp3 --extract-audio";
      ytsubonly = "yt-dlp --skip-download --write-subs";
      ytplaylist = "yt-dlp --output '%(playlist_index)d - %(title)s.%(ext)s'";
    };

    hj.packages = [
      # yt-dlp’s dependencies
      pkgs.ffmpeg
      # `--embed-thumbnail` need this in certain formats
      (pkgs.python313.withPackages (ps: [ps.mutagen]))

      pkgs.yt-dlp # overlay-ed above
    ];

    custom.programs.print-config = let
      conf = pkgs.yt-dlp.configuration.constructFiles.renderedSettings.outPath;
    in {
      yt-dlp =
        # sh
        ''moor "${conf}"'';
    };
  };
}
