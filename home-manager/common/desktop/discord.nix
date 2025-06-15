{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ webcord-vencord ];

  programs.niri.settings = {
    binds = with config.lib.niri.actions; {
      "Mod+W" = {
        action = spawn "webcord";
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
