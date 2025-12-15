{
  config,
  pkgs,
  ...
}: {
  home = {
    pointerCursor = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Nord)";
      size = 38;
      gtk.enable = true;
      x11.enable = true;
    };
  };

  dconf.settings = {
    # disable dconf first use warning
    "ca/desrt/dconf-editor" = {
      show-warning = false;
    };
    # set dark theme for gtk 4
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = config.home.pointerCursor.name;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = ["teal"]; # default: blue
        colorVariants = ["dark"]; # default: all
        sizeVariants = ["compact"]; # default: standard
        tweaks = ["nord"];
      };
      name = "Colloid-Teal-Dark-Compact-Nord";
    };
    iconTheme = {
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["nord"];
        colorVariants = ["teal"]; # default is blue
      };
      name = "Colloid-Teal-Nord-Dark";
    };
    font = {
      name = config.custom.fonts.regular;
      package = pkgs.montserrat;
      size = 14;
    };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      force = true; # plasma seems to override this file?
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-error-bell = 0;
    };
  };
}
