_: let
  inherit (builtins) attrValues;
in {
  flake.modules = {
    nixos.default = {
      config,
      lib,
      pkgs,
      user,
      ...
    }: let
      niriCfg = import ./_config.nix {
        # use home-manager's config
        config = config.hm;
        inherit lib pkgs;
      };
      niriPkg = pkgs.symlinkJoin {
        name = "niri";
        paths = [pkgs.niri];
        buildInputs = [];
        passthru.providedSessions = ["niri"];
        postBuild =
          #sh
          ''
            $out/bin/niri validate -c ${niriCfg}
          '';
      };
    in {
      # niri-nixpkgs
      programs.niri = {
        enable = true;
        package = niriPkg;
        useNautilus = true;
      };

      # portal
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = attrValues {
          inherit
            (pkgs)
            xdg-desktop-portal-gtk
            xdg-desktop-portal-gnome
            ;
        };
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
      # tty autologin
      services.getty.autologinUser = user;

      # dms
      programs.dank-material-shell = {
        enable = true;
        systemd.enable = false;
        # greeter
        greeter = {
          enable = true;
          compositor.name = "niri";
          # User home directory to copy configurations for greeter
          # If DMS config files are in non-standard locations then use the configFiles option instead
          configHome = "/home/${user}";
          configFiles = [
            "/home/${user}/.config/DankMaterialShell/settings.json"
          ];
          logs = {
            save = true;
            path = "/tmp/dms-greeter.log";
          };
        };
      };
    };

    homeManager.default = {
      config,
      lib,
      pkgs,
      ...
    }: let
      dms = ''
        include "dms/alttab.kdl"
        include "dms/binds.kdl"
        include "dms/colors.kdl"
        include "dms/cursor.kdl"
        include "dms/layout.kdl"
        include "dms/outputs.kdl"
        include "dms/windowrules.kdl"
        include "dms/wpblur.kdl"
      '';
    in {
      xdg.configFile."niri/config.kdl" = {
        source = import ./_config.nix {inherit config lib pkgs dms;};
      };
    };
  };
}
