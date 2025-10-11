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
    helium.enable = mkEnableOption "Private, fast, and honest web browser";
  };

  config = mkIf config.custom.helium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.custom.helium;
    };

    custom.persist = {
      home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };
  };
}
