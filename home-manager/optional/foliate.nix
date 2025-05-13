{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    foliate.enable = mkEnableOption "foliate";
  };

  config = lib.mkIf config.custom.foliate.enable {
    home.packages = with pkgs; [ foliate ];

    programs.niri.settings.window-rules = [
      {
        matches = [ { app-id = "^(com.github.johnfactotum.Foliate)$"; } ];
        default-column-width.proportion = 0.9;
      }
    ];

    custom.persist = {
      home.cache.directories = [
        ".cache/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
