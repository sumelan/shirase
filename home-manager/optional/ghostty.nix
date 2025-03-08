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
        confirm-close-surface = false;
        copy-on-select = true;
        cursor-style = "bar";
        font-feature = "zero";
        font-style = "Medium";
        minimum-contrast = 1.1;
        window-decoration = false;
      };
    };
  };
}
