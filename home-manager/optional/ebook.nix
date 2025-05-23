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
    home.packages = with pkgs; [
      foliate
      mcomix
    ];

    programs.niri.settings.window-rules = [
      {
        matches = [
          { app-id = "^(com.github.johnfactotum.Foliate)$"; }
          { app-id = "^(MComix)$"; }
        ];
        default-column-width.proportion = 0.9;
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
