_: {
  flake.custom.hjemConfigs.wm = {pkgs, ...}: {
    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = ["gnome"];
        obs.default = ["gnome"];
      };
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
