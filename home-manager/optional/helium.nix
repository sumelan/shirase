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
    # declarative extentions through home-manager seem to be installed as chromium's extentions!
    custom.persist = {
      home.directories = [
        ".cache/net.imput.helium"
        ".config/net.imput.helium"
      ];
    };
  };
}
