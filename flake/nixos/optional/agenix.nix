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
  imports = [inputs.agenix.nixosModules.default];

  options.custom = {
    agenix.enable =
      mkEnableOption "agenix";
  };

  config = {
    environment.systemPackages = [inputs.agenix.packages."${pkgs.system}".default];
    age.secrets.api-key =
      mkIf config.custom.agenix.enable {};
  };
}
