{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    ebook.enable = mkEnableOption "ebook reader";
  };

  config = lib.mkIf config.custom.ebook.enable {
    home.packages = with pkgs; [ foliate ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(com.github.johnfactotum.Foliate)$"; } ];
        default-column-width.proportion = 0.9;
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
