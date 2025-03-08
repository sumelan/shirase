{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    zathura.enable = mkEnableOption "zathura" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.zathura.enable {
    programs = {
      zathura = {
        enable = true;
        mappings = {
          u = "scroll half-up";
          d = "scroll half-down";
          D = "toggle_page_mode";
          r = "reload";
          R = "rotate";
          K = "zoom in";
          J = "zoom out";
          p = "print";
          i = "recolor";
        };
        options = {
          statusbar-h-padding = 0;
          statusbar-v-padding = 0;
          page-padding = 1;
          adjust-open = "best-fit";
          recolor = true; # invert by default
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
    };

    stylix.targets.zathura.enable = true;
  };
}
