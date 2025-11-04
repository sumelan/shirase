{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    euphonica.enable = mkEnableOption "An MPD client with delusions of grandeur, made with Rust, GTK and Libadwaita.";
  };

  config = mkIf config.custom.euphonica.enable {
    home.packages = [pkgs.euphonica];

    custom.persist = {
      home.directories = [
        ".cache/euphonica"
      ];
    };
  };
}
