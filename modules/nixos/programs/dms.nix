{inputs, ...}: {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    ...
  }: {
    # tty autologin
    services.getty.autologinUser = user;

    # dms-related
    programs = {
      dank-material-shell = {
        enable = true;
        systemd.enable = true;

        # greeter
        greeter = {
          enable = true;
          compositor.name = "niri";
          configHome = config.hj.directory;
          logs = {
            save = true;
            path = "/tmp/dms-greeter.log";
          };
        };
      };

      dsearch = {
        enable = true;
        package = inputs.dsearch.packages.${pkgs.stdenv.hostPlatform.system}.default;
        systemd.enable = true;
      };
    };

    systemd.user = let
      dmsConf = "${config.hj.xdg.config.directory}/niri/dms";
    in {
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
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/niri/dms"
        ".config/DankMaterialShell/themes"
        ".local/state/DankMaterialShell"
      ];
      cache = {
        root.directories = [
          "/var/lib/dms-greeter/.cache"
          "/var/lib/dms-greeter/.local"
        ];
        home.directories = [
          ".cache/DankMaterialShell"
        ];
      };
    };
  };
}
