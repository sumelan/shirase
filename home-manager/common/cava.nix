{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  programs = {
    cava = {
      enable = true;
    };

    niri.settings = {
      binds = {
        "Mod+C" = lib.custom.niri.openTerminal {
          app = pkgs.cava;
          terminal = config.profiles.${user}.defaultTerminal.package;

        };
      };
      window-rules = [
        {
          matches = [ { app-id = "^(cava)$"; } ];
          default-column-width.proportion = 0.4;
          default-window-height.proportion = 0.4;
          open-floating = true;
        }
      ];
    };
  };
  stylix.targets.cava.rainbow.enable = true;
}
