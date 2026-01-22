_: {
  flake.modules.homeManager.default = {config, ...}: let
    inherit (config.xdg) cacheHome;
    inherit (config.xdg.userDirs) documents pictures;
    projDir = "${config.home.homeDirectory}/Projects";
  in {
    programs.dsearch = {
      enable = true;
      config = {
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
            path = projDir;
            max_depth = 8;
            exclude_hidden = true;
            exclude_dirs = ["node_modules" ".git" "target" "dist"];
          }
        ];
      };
    };
  };
}
