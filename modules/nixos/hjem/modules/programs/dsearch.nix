{lib, ...}: {
  flake.custom.hjemModules.dsearch = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.rum.programs.dsearch;
    tomlFmt = pkgs.formats.toml {};
  in {
    options.rum = {
      programs.dsearch = {
        enable = lib.mkEnableOption "dsearch, a fast filesystem search service with fuzzy matching";

        package = lib.mkPackageOption pkgs "dsearch" {};

        settings = lib.mkOption {
          inherit (tomlFmt) type;
          description = ''
            Configuration included in `config.toml`.
            See <https://github.com/AvengeMedia/danksearch/blob/master/config.example.toml>
            for available options.
          '';
        };
      };
    };

    config = lib.mkIf cfg.enable {
      packages = [cfg.package];

      systemd.services.dsearch = let
        dsearchConf = tomlFmt.generate "config.toml" cfg.settings;
      in {
        description = "dsearch - Fast filesystem search service";
        documentation = ["https://github.com/AvengeMedia/dsearch"];
        after = ["network.target"];
        wantedBy = ["default.target"];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe cfg.package} -c ${dsearchConf} serve";
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
