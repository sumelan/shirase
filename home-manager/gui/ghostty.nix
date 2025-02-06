{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.ghostty;
in
{
  options.custom = with lib; {
    ghostty = {
      enable = mkEnableOption "ghostty" // {
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        # adjust-cell-height = 1;
        background = "#000000";
        confirm-close-surface = false;
        copy-on-select = true;
        cursor-style = "bar";
        font-feature = "zero";
        font-style = "Medium";
        minimum-contrast = 1.1;
        # term = "xterm-kitty";
        # theme = "catppuccin-mocha";
        window-decoration = false;
      };
    };
  };
}
