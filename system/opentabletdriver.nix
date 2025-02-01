{ lib, config, ... }:
with lib;
let
  cfg = config.custom.opentabletdriver;
in
{
  options.custom.opentabletdriver = {
    enable = mkEnableOption "Enable opentabletdriver";
  };

  config = mkIf cfg.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };
}
