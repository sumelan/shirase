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
      package = pkgs.orchis-theme.override {
        border-radius = 5; # Suggested: 2 < value < 16
        tweaks = ["nord"]; # can be "solid" "compact" "black" "primary" "macos" "submenu" "nord|dracula"
      };
      name = "Orchis-Grey-Dark-Compact-Nord";
    };
    iconTheme = {
      package = pkgs.papirus-nord.override {
        # valid accent:
        # `auroragreen`, `auroragreenb`, `auroramagenta`, `auroramagentab`, `auroraorange`, `auroraorangeb`,
        # `aurorared`, `auroraredb`, `aurorayellow`, `aurorayellowb`, `frostblue1`, `frostblue2`, `frostblue3`,
        # `frostblue4`, `polarnight1`, `polarnight2`, `polarnight3`, `polarnight3`, `snowstorm1`, `snowstorm1b`
        accent = "polarnight3";
      };
      name = "Papirus-Dark";
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
