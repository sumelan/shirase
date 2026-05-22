{config, ...}: let
  cache = config.hj.xdg.cache.directory;
  documents = "${config.hj.directory}/Documents";
  pictures = "${config.hj.directory}/Pictures";
  music = "${config.hj.directory}/Music";
  videos = "${config.hj.directory}/Videos";
  pj = "${config.hj.directory}/Projects";
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
      path = config.hj.directory;
      max_depth = 0;
      exclude_hidden = true;
      extract_exif = false;
      exclude_dirs = ["Projects"];
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
      extract_exif = true; # Extract EXIF metadata from images
      exclude_dirs = ["Wallpapers"];
    }
    {
      path = music;
      max_depth = 0;
      exclude_hidden = true;
      extract_exif = false;
      exclude_dirs = [];
    }
    {
      path = videos;
      max_depth = 0;
      exclude_hidden = true;
      extract_exif = true;
      exclude_dirs = [];
    }
  ];
}
