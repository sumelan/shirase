{
  inputs,
  config,
  lib,
  ...
}: {
  flake.custom.hjemConfigs.nushell = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
    inshellah = inputs.inshellah.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hjem.users.${user} = {
      packages = [local.nushell];

      systemd.services = {
        inshellah-index = {
          description = "Indexes packages installed per-user";
          after = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          path = [local.nushell];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${lib.getExe inshellah} index /etc/profiles/per-user/${user}";
          };
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/nushell"
      ];
    };
  };
}
