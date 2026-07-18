{lib, ...}: let
  inherit (lib) mkPackageOption mkEnableOption;
in {
  flake.custom.hjemModules.ghostty = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.ghostty;
  in {
    options.rum = {
      programs.ghostty = {
        enable = mkEnableOption "Ghostty";

        package = mkPackageOption pkgs "ghostty" {};

        systemd = {
          enable = mkEnableOption "The ghostty systemd user service";
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

      xdg = {
        data.files."dbus-1/services/com.mitchellh.ghostty.service".text = ''
          [D-BUS Service]
          Name=com.mitchellh.ghostty
          SystemdService=app-com.mitchellh.ghostty.service
          Exec=${lib.getExe cfg.package} --gtk-single-instance=true --initial-window=false
        '';

        config.files."ghostty/config.ghostty" = {
          permissions = "666";
          text = "";
          type = "copy";
        };
      };
    };
  };
}
