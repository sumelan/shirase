{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    swayimg.enable = mkEnableOption "swayimg" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.swayimg.enable {
    home.packages = with pkgs; [
      swayimg
    ];

    xdg.mimeApps.defaultApplications = {
      "image/jpeg" = "swayimg.desktop";
      "image/gif" = "swayimg.desktop";
      "image/webp" = "swayimg.desktop";
      "image/png" = "swayimg.desktop";
    };
  };
}
