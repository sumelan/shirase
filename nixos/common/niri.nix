{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

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
      common.default = ["gnome"];
      niri = {
        default = "gnome";
        "org.freedesktop.impl.portal.FileChooser" = "gtk";
      };
      obs.default = ["gnome"];
    };
  };
}
