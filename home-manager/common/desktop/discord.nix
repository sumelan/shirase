{
  lib,
  pkgs,
  ...
}:
let
  discordPkgs = pkgs.webcord-vencord;
in
{
  home.packages = [ discordPkgs ];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = lib.custom.niri.useUwsm (
          lib.concatStringsSep " " [
            "webcord"
            "--enable-wayland-ime --wayland-text-input-version=3"
          ]
        );
        hotkey-overlay.title = "Launch WebCord";
      };
    };
    window-rules = lib.singleton {
      matches = lib.singleton {
        app-id = "^(WebCord)$";
      };
      default-column-width.proportion = 0.7;
    };
  };

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
  stylix.targets.vencord.enable = false;
}
