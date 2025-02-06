{
  config,
  isLaptop,
  lib,
  ...
}:
{
  options.custom = with lib; {
    niri = {
      lock = mkEnableOption "locking of host" // {
        default = isLaptop;
      };
    };
  };

  config = lib.mkIf (config.custom.niri.enable && config.custom.niri.lock) {
    programs.hyprlock.enable = true;
  };
}
