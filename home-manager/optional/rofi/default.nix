{
  lib,
  config,
  pkgs,
  ...
}: {
  options.custom = {
    rofi.enable = lib.mkEnableOption "Rofi";
  };

  config = lib.mkIf config.custom.rofi.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      extraConfig = {
        modi = "drun, run, ssh";
        show-icons = true;
        icon-theme = config.stylix.icons.dark;
      };
    };
  };
}
