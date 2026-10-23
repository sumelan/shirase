{
  inputs,
  pkgs,
  ...
}: let
  snapshot-explorer = inputs.snapshot-explorer.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment = {
    systemPackages = [
      snapshot-explorer
    ];

    sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
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
}
