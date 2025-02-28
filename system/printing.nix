{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    printing.enable = mkEnableOption "printing";
  };

  config = lib.mkIf config.custom.printing.enable {
    services.printing = {
      enable = true;
      browsed.enable = true;
      drivers = with pkgs; [
        # drivers here
      ];
    };
  };
}
