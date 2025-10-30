{pkgs, ...}: {
  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
  niri-flake.cache.enable = true;
  # use gnome-polkit instead
  systemd.user.services.niri-flake-polkit.enable = false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = builtins.attrValues {
      inherit
        (pkgs)
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        ;
    };
    config = {
      common.default = ["gtk" "gnome"];
      niri.default = ["gtk" "gnome"];
      obs.default = ["gnome"];
    };
  };
}
