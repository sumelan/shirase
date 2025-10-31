{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    vlc.enable = mkEnableOption "vlc";
  };

  config = mkIf config.custom.vlc.enable {
    home.packages = [pkgs.vlc];
  };
}
