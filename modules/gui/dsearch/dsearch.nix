{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    dsearch = inputs.danksearch.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    hj = {
      packages = [dsearch];

      systemd.services = {
        dsearch = {
          description = "dsearch - Fast filesystem search service";
          documentation = ["https://github.com/AvengeMedia/dsearch"];
          after = ["network.target"];
          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${getExe dsearch} serve";
            Restart = "on-failure";
            RestartSec = "5s";

            StandardOutput = "journal";
            StandardError = "journal";
            SyslogIdentifier = "dsearch";
          };
        };
      };

      xdg.config.files."danksearch/config.toml" = {
        generator = (pkgs.formats.toml {}).generate "config.toml";
        value = import ./_config.nix {inherit config;};
      };
    };
  };
}
