{ config, ... }:
{
  programs = {
    cava.enable = true;

    niri.settings = {
      binds =
        with config.lib.niri.actions;
        let
          ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
        in
        {
          "Mod+C" = {
            action = ush "${config.custom.terminal.exec} -T ' Cava' --app-id cava cava";
            hotkey-overlay.title = "Cava";
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
