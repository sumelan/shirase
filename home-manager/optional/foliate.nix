{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    foliate.enable = lib.mkEnableOption "ebook reader";
  };

  config = lib.mkIf config.custom.foliate.enable {
    home.packages = with pkgs; [ foliate ];

    programs.niri.settings.window-rules = [
      {
        matches = lib.singleton {
          app-id = "^(com.github.johnfactotum.Foliate)$";
        };
        block-out-from = "screen-capture";
      }
    ];

    custom.persist = {
      home = {
        directories = [
          ".local/share/com.github.johnfactotum.Foliate"
        ];
        cache.directories = [
          ".cache/com.github.johnfactotum.Foliate"
        ];
      };
    };
  };
}
