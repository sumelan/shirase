{
  inputs,
  pkgs,
  ...
}: {
  programs = {
    niri = {
      enable = true;
      package = pkgs.niri;
    };
    dankMaterialShell = {
      enable = true;
      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
      };
      quickshell = {
        package = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
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
        default = ["gtk" "gnome"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      };
      obs.default = ["gnome"];
    };
  };
}
