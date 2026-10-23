{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
  inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  systemd.services.inshellah-index = {
    description = "Indexes packages installed per-user";
    after = ["graphical-session.target"];
    wantedBy = ["graphical-session.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${getExe inshellah} index /etc/profiles/per-user/sumelan";
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".config/nushell"
    ];
  };
}
