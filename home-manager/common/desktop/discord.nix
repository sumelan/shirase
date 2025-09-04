{
  lib,
  config,
  ...
}: let
  inherit
    (lib.custom.niri)
    openApp
    ;
  discordPkgs = config.programs.vesktop.package;
in {
  programs.vesktop = {
    enable = true;
  };

  programs.niri.settings = {
    binds = {
      "Mod+W" = openApp {
        app = discordPkgs;
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
