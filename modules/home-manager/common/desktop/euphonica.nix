{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.custom.colors) blue2;
  inherit (lib.custom.niri) spawn hotkey;
in {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      cyanrip
      euphonica
      picard
      ;
  };

  programs.niri.settings.binds = {
    "Mod+E" = {
      action.spawn = spawn "euphonica";
      hotkey-overlay.title = hotkey {
        color = blue2;
        name = "󱗆  Euphonica";
        text = "GTK4 libadwaita MPD Client";
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".cache/euphonica"
    ];
  };
}
