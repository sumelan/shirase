_: {
  flake.modules.nixos = {
    gui = {user, ...}: {
      # tty autologin
      services.getty.autologinUser = user;

      # dms
      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
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

    hjem-gui = {
      config,
      user,
      ...
    }: let
      dmsConf = "${config.hj.xdg.config.directory}/niri/dms";
    in {
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
      };

      custom.fileSystem = {
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
