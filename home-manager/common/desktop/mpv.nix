{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) singleton;
in {
  home.packages = [pkgs.mpv];

  custom.persist = {
    home.directories = [
      ".local/state/mpv" # watch later
    ];
  };

  programs.niri.settings.window-rules = [
    {
      matches = singleton {
        app-id = "^(mpv)$";
      };
      open-floating = true;
      default-column-width.proportion = 0.50;
      default-window-height.proportion = 0.50;
      opacity = 1.0;
    }
  ];
}
