{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: let
    dsearch = inputs.danksearch.packages.${pkgs.stdenv.hostPlatform.system}.default;
    tomlFormat = pkgs.formats.toml {};
    inherit (config.xdg) cacheHome;
    inherit (config.xdg.userDirs) documents pictures;
    pjDir = "${config.home.homeDirectory}/Projects";
  in {
    home.packages = [dsearch];

    systemd.user.services = {
      dsearch = {
        Unit = {
          Description = "dsearch - Fast filesystem search service";
          Documentation = "https://github.com/AvengeMedia/dsearch";
          After = ["network.target"];
        };

        Service = {
          Type = "simple";
          ExecStart = "${getExe dsearch} serve";
          Restart = "on-failure";
          RestartSec = "5s";

          StandardOutput = "journal";
          StandardError = "journal";
          SyslogIdentifier = "dsearch";
        };

        Install = {
          WantedBy = ["default.target"];
        };
      };
    };

    xdg.configFile."danksearch/config.toml" = {
      source = tomlFormat.generate "dsearch-config.toml" {
        # Server configuration
        listen_addr = ":43654";

        # Index settings
        index_path = "${cacheHome}/danksearch/index";
        max_file_bytes = 2097152; # 2MB
        worker_count = 4;
        index_all_files = true;

        # Auto-reindex settings
        auto_reindex = false;
        reindex_interval_hours = 24;

        # Text file extensions
        text_extensions = [
          ".txt"
          ".md"
          ".go"
          ".py"
          ".js"
          ".ts"
          ".jsx"
          ".tsx"
          ".json"
          ".yaml"
          ".yml"
          ".toml"
          ".html"
          ".css"
          ".rs"
        ];

        # Index paths configuration
        index_paths = [
          {
            path = documents;
            max_depth = 6;
            exclude_hidden = true;
            exclude_dirs = ["node_modules" "venv" "target"];
          }
          {
            path = pictures;
            max_depth = 6;
            exclude_hidden = true;
            exclude_dirs = ["node_modules" "venv" "target"];
          }
          {
            path = pjDir;
            max_depth = 8;
            exclude_hidden = true;
            exclude_dirs = ["node_modules" ".git" "target" "dist"];
          }
        ];
      };
    };
  };
}
