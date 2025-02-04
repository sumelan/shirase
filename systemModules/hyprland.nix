{
  lib,
  pkgs,
  config,
  ...
}:
lib.mkIf config.hm.custom.hyprland.enable {
  programs.hyprland = {
    enable = true;

    # needed for setting the wayland environment variables
    withUWSM = true;
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
