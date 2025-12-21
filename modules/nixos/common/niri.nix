{
  lib,
  pkgs,
  user,
  ...
}: let
  inherit (lib) mkMerge;
in
  mkMerge [
    # niri
    {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
        # manually set instead
        useNautilus = true;
      };
    }
    # portal
    {
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
          common.default = ["gtk"];
          niri = {
            # use Nautilus
            "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
            "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
          };
          obs.default = ["gnome"];
        };
      };
    }
    # dms
    {
      programs.dank-material-shell = {
        enable = true;
        systemd.enable = false;
      };
    }
    # greeter
    {
      # tty autologin
      services.getty.autologinUser = user;

      programs.dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
        configHome = "/home/${user}";
        configFiles = [
          "/home/${user}/.config/DankMaterialShell/default-settings.json"
        ];
        logs = {
          save = true;
          path = "/tmp/dms-greeter.log";
        };
      };
    }
  ]
