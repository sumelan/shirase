{
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  flake.modules = {
    nixos.default = {user, ...}: {
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
      pkgs,
      user,
      ...
    }: let
      dmsConf = "${config.xdg.configHome}/niri/dms";
    in {
      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        dgop.package = inputs.dgop.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      systemd.user = {
        tmpfiles.rules = [
          # create dms kdl files if not existed
          "f ${dmsConf}/alttab.kdl 644 ${user} users - -"
          "f ${dmsConf}/binds.kdl 644 ${user} users - -"
          "f ${dmsConf}/colors.kdl 644 ${user} users - -"
          "f ${dmsConf}/layout.kdl 644 ${user} users - -"
          "f ${dmsConf}/outputs.kdl 644 ${user} users - -"
          "f ${dmsConf}/windowrules.kdl 644 ${user} users - -"
          "f ${dmsConf}/wpblur.kdl 644 ${user} users - -"
          "f ${dmsConf}/cursor.kdl 644 ${user} users - -"
        ];
        # override service config flake provide
        services.dms.Service.Restart = mkForce "always";
      };

      custom = {
        persist.home.directories = [
          ".config/niri/dms"
          ".local/state/DankMaterialShell"
        ];
        cache.home.directories = [
          ".cache/DankMaterialShell"
        ];
      };
    };
  };
}
