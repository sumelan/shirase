{lib, ...}: {
  flake.modules.nixos.mpdris2-rs = {
    config,
    pkgs,
    ...
  }: {
    hj.systemd.services = {
      mpdris2-rs = {
        description = "Music Player Daemon D-Bus Bridge";
        wants = ["mpd.service"];
        after = ["mpd.service"];
        wantedBy = ["default.target"];

        serviceConfig = {
          Type = "dbus";
          BusName = "org.mpris.MediaPlayer2.mpd";
          Restart = "on-failure";
          ExecStart = "${lib.getExe pkgs.mpdris2-rs} --host ${config.custom.services.mpd.settings.bind_to_address}";
        };
      };
    };
  };
}
