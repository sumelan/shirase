{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options.custom = {
    agenix.enable = mkEnableOption "agenix";
  };

  config = mkIf config.custom.agenix.enable {
    environment.systemPackages = [inputs.agenix.packages."${pkgs.system}".default];
  };
}
