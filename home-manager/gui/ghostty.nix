{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    ghostty = {
      enable = mkEnableOption "ghostty";
    };
  };

  config = lib.mkIf config.custom.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        background-opacity = config.stylix.opacity.terminal;
        confirm-close-surface = false;
        copy-on-select = true;
        cursor-style = "bar";
        font-family = config.stylix.fonts.monospace;
        font-feature = "zero";
        font-size = config.stylix.fonts.size.terminal;
        font-style = "Medium";
        minimum-contrast = 1.1;
        window-decoration = false;
      };
    };
  };
}
