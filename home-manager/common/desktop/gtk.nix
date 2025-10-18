{
  config,
  pkgs,
  ...
}: {
  home = {
    pointerCursor = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
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
      package = pkgs.tokyo-night-gtk.override {
        colorVariants = ["dark"];
        sizeVariants = ["compact"];
        themeVariants = ["all"];
      };
      name = "Tokyonight-Dark-Compact";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme.override {
        color = "green";
      };
      name = "Papirus-Dark";
    };
    font = {
      name = config.custom.fonts.regular;
      package = pkgs.geist-font;
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
