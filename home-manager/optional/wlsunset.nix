{
  lib,
  config,
  ...
}:
{
  options.custom = {
    wlsunset.enable = lib.mkEnableOption "wlsunset";
  };

  config = lib.mkIf config.custom.wlsunset.enable {
    services.wlsunset = {
      enable = true;
      # japan
      latitude = 36.2;
      longitude = 138.3;
    };
  };
}
