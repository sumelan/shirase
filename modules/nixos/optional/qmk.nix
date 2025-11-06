{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    qmk.enable = mkEnableOption "QMK keyboards";
  };

  config = mkIf config.custom.qmk.enable {
    hardware.keyboard.qmk = {
      enable = true;
      keychronSupport = true;
    };
  };
}
