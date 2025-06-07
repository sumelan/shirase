{ config, ... }:
{
  programs.cava.enable = true;

  programs.niri.settings = {
    binds = with config.lib.niri.actions; {
      "Mod+C" = {
        action = spawn "ghostty" "-e" "cava";
        hotkey-overlay.title = "Cava";
      };
    };
  };

  stylix.targets.cava = {
    enable = true;
    rainbow.enable = true;
  };
}
