{
  inputs,
  lib,
  ...
}: {
  flake.custom.hjemConfigs.dsearch = {
    config,
    pkgs,
    ...
  }: let
    dsearch = inputs.dsearch.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hj = {
      packages = [dsearch];

      systemd.services.dsearch = let
        dsearchConf = (pkgs.formats.toml {}).generate "config.toml" (import ./_config.nix {inherit config;});
      in {
        description = "dsearch - Fast filesystem search service";
        documentation = ["https://github.com/AvengeMedia/dsearch"];
        after = ["network.target"];
        wantedBy = ["default.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe dsearch} -c ${dsearchConf} serve";
          Restart = "on-failure";
          RestartSec = "5s";
          StandardOutput = "journal";
          StandardError = "journal";
          SyslogIdentifier = "dsearch";
        };
      };
    };
  };
}
