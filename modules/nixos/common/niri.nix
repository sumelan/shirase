{
  inputs,
  pkgs,
  user,
  ...
}: let
  qsPkgs = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  programs = {
    niri = {
      enable = true;
      package = pkgs.niri;
    };
    dankMaterialShell = {
      enable = true;
      quickshell.package = qsPkgs;

      greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/${user}";
        configFiles = [
          "/home/${user}/.config/DankMaterialShell/settings.json"
        ];
        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
        quickshell.package = qsPkgs;
      };
    };
  };

  niri-flake.cache.enable = true;

  # use dns polkit instead
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
  # tty autologin
  services.getty.autologinUser = user;
}
