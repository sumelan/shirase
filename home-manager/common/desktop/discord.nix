{
  lib,
  config,
  ...
}:
let
  discordPkgs = config.programs.vesktop.package;
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
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
