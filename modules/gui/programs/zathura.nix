_: {
  flake.modules.homeManager.default = _: {
    programs.zathura = {
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

    xdg.mimeApps = let
      value = "org.pwmt.zathura-pdf-mupdf.desktop";
      associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/png"
        ]);
    in {
      associations.removed = associations;
    };
  };
}
