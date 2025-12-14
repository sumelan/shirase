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
    ;
in {
  options.custom = {
    foliate.enable = mkEnableOption "ebook reader";
  };

  config = mkIf config.custom.foliate.enable {
    home.packages = [pkgs.foliate];

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
