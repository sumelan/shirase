{
  lib,
  config,
  pkgs,
  ...
}: let
  ymPkgs = pkgs.callPackage pkgs.symlinkJoin {
    name = "youtube-music";
    paths = [
      pkgs.youtube-music
    ];
    buildInputs = [
      pkgs.makeWrapper
    ];
    postBuild = ''
      wrapProgram $out/bin/youtube-music \
        --add-flags '--enable-wayland-ime --wayland-text-input-version=3'
    '';
  };
in {
  options.custom = {
    youtube-music.enable = lib.mkEnableOption "YoutubeMusic";
  };

  config = lib.mkIf config.custom.youtube-music.enable {
    home.packages = [ymPkgs];

    programs.niri.settings = {
      binds = {
        "Mod+M" = lib.custom.niri.openApp {
          app = ymPkgs;
        };
      };
    };

    custom.persist = {
      home.directories = [
        ".config/YouTube Music"
      ];
    };
  };
}
