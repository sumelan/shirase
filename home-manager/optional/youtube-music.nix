{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    youtube-music.enable = mkEnableOption "YoutubeMusic";
  };

  config = lib.mkIf config.custom.youtube-music.enable {
    home.packages = [
      pkgs.playerctl
      (pkgs.callPackage pkgs.symlinkJoin {
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
      })
    ];

    services.playerctld.enable = true;

    programs.niri.settings = {
      binds =
        with config.lib.niri.actions;
        let
          ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
        in
        {
          "Mod+Y" = {
            action = ush "youtube-music";
            hotkey-overlay.title = "YouTube Music";
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
