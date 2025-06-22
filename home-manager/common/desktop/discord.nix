{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ webcord ];

  programs.niri.settings = {
    binds =
      with config.lib.niri.actions;
      let
        ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
      in
      {
        "Mod+W" = {
          action = ush "webcord";
          hotkey-overlay.title = "WebCord";
        };
      };
    window-rules = [
      {
        matches = [ { app-id = "^(WebCord)$"; } ];
        default-column-width.proportion = 0.7;
        block-out-from = "screen-capture";
      }
    ];
  };

  custom.persist = {
    home.directories = [
      ".config/WebCord"
    ];
  };
}
