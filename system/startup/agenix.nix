{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.custom = with lib; {
    agenix.enable = mkEnableOption "agenix";
  };

  config = lib.mkIf config.custom.agenix.enable {
    environment.systemPackages = [ inputs.agenix.packages."${pkgs.system}".default ];
  };
}
