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
    printing.enable = mkEnableOption "printing";
  };

  config = mkIf config.custom.printing.enable {
    services.printing = {
      enable = true;
      browsed.enable = true;
      drivers = with pkgs; [
        # drivers here
      ];
    };
  };
}
