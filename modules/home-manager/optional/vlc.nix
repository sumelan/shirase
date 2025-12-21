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
    vlc.enable = mkEnableOption "vlc";
  };

  config = mkIf config.custom.vlc.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs) vlc handbrake;
    };

    custom.persist = {
      home = {
        files = [
          ".config/aacs/KEYDB.cfg"
        ];
        directories = [
          ".config/vlc"
        ];
      };
    };
  };
}
