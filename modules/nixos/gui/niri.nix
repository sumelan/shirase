_: {
  flake.modules.nixos.gui = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      useNautilus = true;
      withUWSM = false;
      withXDG = true;
    };

    xdg.portal = {
      config = {
        common.default = ["gtk"];
        niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = ["gtk"];
          # i use nautilus
          "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
          "org.freedesktop.impl.portal.Notification" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        };
      };
    };
  };
}
