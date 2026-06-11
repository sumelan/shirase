_: {
  flake.custom.hjemConfigs.dsearch = {
    config,
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      programs.dsearch = {
        enable = true;

        package = pkgs.dsearch;

        settings = let
          cache = config.hjem.users.${user}.xdg.cache.directory;
          documents = "${config.hjem.users.${user}.directory}/Documents";
          pictures = "${config.hjem.users.${user}.directory}/Pictures";
          videos = "${config.hjem.users.${user}.directory}/Videos";
        in {
          # Server configuration
          listen_addr = ":43654";

          # Index settings
          index_path = "${cache}/danksearch/index";
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
              path = config.hjem.users.${user}.directory;
              max_depth = 0;
              exclude_hidden = true;
              extract_exif = false;
              exclude_dirs = ["Music" "Projects"];
            }
            {
              path = documents;
              max_depth = 0;
              exclude_hidden = true;
              extract_exif = false;
              exclude_dirs = [];
            }
            {
              path = pictures;
              max_depth = 0;
              exclude_hidden = true;
              extract_exif = false; # Extract EXIF metadata from images
              exclude_dirs = ["Wallpapers"];
            }
            {
              path = videos;
              max_depth = 0;
              exclude_hidden = true;
              extract_exif = false;
              exclude_dirs = [];
            }
          ];
        };
      };
    };
  };
}
