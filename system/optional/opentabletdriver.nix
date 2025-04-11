{
  lib,
  config,
  ...
}:
{
  options.custom = with lib; {
    opentabletdriver.enable = mkEnableOption "Enable opentabletdriver" // {
      default = config.hm.custom.krita.enable;
    };
  };

  config = lib.mkIf config.custom.opentabletdriver.enable {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };

    custom.persist = {
      home.directories = [
        ".config/OpenTabletDriver"
      ];
    };
  };
}
