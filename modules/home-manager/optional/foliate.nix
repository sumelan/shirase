{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
in {
  options.custom = {
    foliate.enable = mkEnableOption "ebook reader";
  };

  config = mkIf config.custom.foliate.enable {
    home.packages = [pkgs.foliate];

    programs.niri.settings.window-rules = [
      {
        matches = singleton {
          app-id = "^(com.github.johnfactotum.Foliate)$";
        };
        block-out-from = "screen-capture";
      }
    ];

    custom.persist = {
      home.directories = [
        ".local/share/com.github.johnfactotum.Foliate"
        ".cache/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
