{
  lib,
  config,
  pkgs,
  ...
}:
let
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
in
{
  options.custom = with lib; {
    youtube-music.enable = mkEnableOption "YoutubeMusic";
  };

  config = lib.mkIf config.custom.youtube-music.enable {
    home.packages = [ ymPkgs ];

    services.playerctld.enable = true;

    programs.niri.settings = {
      binds = {
        "Mod+Y" = config.niri-lib.open {
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
