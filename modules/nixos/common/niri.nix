{
  lib,
  pkgs,
  user,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkForce
    getExe
    mkMerge
    ;
  dmsPkgs = inputs.dankMaterialShell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
in
  mkMerge [
    # niri-flake
    {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      niri-flake.cache.enable = true;
      # use dms' built-in polkit
      systemd.user.services.niri-flake-polkit.enable = false;
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
    # dms
    {
      programs.dankMaterialShell = {
        enable = true;
        systemd.enable = false;
      };
      # systemd setup
      systemd.user.services.dms-shell = {
        description = "DankMaterialShell";
        path = mkForce [];
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        restartIfChanged = true;
        serviceConfig = {
          ExecStart = getExe dmsPkgs + " run --session";
          Restart = "always";
        };
      };
    }
    # greeter
    {
      # tty autologin
      services.getty.autologinUser = user;

      programs.dankMaterialShell.greeter = {
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
