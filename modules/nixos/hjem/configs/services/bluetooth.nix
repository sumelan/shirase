{lib, ...}: {
  flake.modules.nixos.blueman-applet = {pkgs, ...}: {
    systemd.services = {
      blueman-applet = {
        description = "Blueman applet";
        requires = ["tray.target"];
        after = ["graphical-session.target"] ++ ["tray.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];

        serviceConfig = {
          ExecStart = lib.getExe' pkgs.blueman "blueman-applet";
        };
      };
    };
  };
}
