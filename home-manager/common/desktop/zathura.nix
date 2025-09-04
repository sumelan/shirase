{lib, ...}: let
  inherit
    (lib)
    singleton
    ;
in {
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
        recolor = false;
      };
    };
  };
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura.desktop";
  };

  programs.niri.settings.window-rules = [
    {
      matches = singleton {
        app-id = "^(org.pwmt.zathura)$";
      };
      default-column-width.proportion = 0.9;
    }
  ];
}
