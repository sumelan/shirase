{
  lib,
  pkgs,
  ...
}:
let
  discordPkgs = pkgs.pkgs.vesktop;
in
{
  programs.vesktop = {
    enable = true;
  };

  programs.niri.settings = {
    binds = {
      "Mod+W" = lib.custom.niri.openApp {
        app = discordPkgs;
      };
    };
    window-rules = lib.singleton {
      matches = lib.singleton {
        app-id = "^(vesktop)$";
      };
      default-column-width.proportion = 0.7;
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
