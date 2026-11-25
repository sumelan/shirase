{pkgs, ...}: let
  inherit
    (pkgs.lib)
    getExe'
    ;
in {
  hjem.users.sumelan = {
    packages = [pkgs.pwvucontrol];

    systemd.services = {
      # mpris user service to control media player over bluetooth
      mpris-proxy = {
        description = "Proxy forwarding Bluetooth MIDI controls via MPRIS2 to control media players";
        bindsTo = ["bluetooth.target"];
        after = ["bluetooth.target"];
        wantedBy = ["bluetooth.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = getExe' pkgs.bluez "mpris-proxy";
        };
      };
    };
  };
}
