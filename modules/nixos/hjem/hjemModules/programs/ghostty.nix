{lib, ...}: {
  flake.custom.hjemModules.ghostty = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.ghostty;
  in {
    options.rum = {
      programs.ghostty = {
        enable = lib.mkEnableOption "Ghostty";

        package = lib.mkPackageOption pkgs "ghostty" {};

        systemd = {
          enable = lib.mkEnableOption "The ghostty systemd user service";
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      systemd.services."app-com.mitchellh.ghostty" = lib.mkIf cfg.systemd.enable {
        description = "Ghostty";
        path = [
          "/run/current-system/sw"
          "/etc/profiles/per-user/${config.user}"
        ];

        requires = ["dbus.socket"];
        after = ["graphical-session.target" "dbus.socket"];
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          Type = "notify-reload";
          ReloadSignal = "SIGUSR2";
          BusName = "com.mitchellh.ghostty";
          ExecStart = "${lib.getExe cfg.package} --gtk-single-instance=true --initial-window=false";
        };
      };

      rum.dbus.packages = [cfg.package];

      xdg = {
        mime-apps.default-applications = {
          "x-scheme-handler/terminal" = "ghostty.desktop";
        };

        config.files."ghostty/config.ghostty" = {
          permissions = "666";
          text = "";
          type = "copy";
        };
      };
    };
  };
}
