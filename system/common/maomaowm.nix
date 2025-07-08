{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.maomaowm.nixosModules.maomaowm ];

  options.custom = {
    maomaowm = {
      enable = lib.mkEnableOption "Enable maomaowm";
      uwsm.enable = lib.mkEnableOption "Using uwsm with maomaowm";
    };
  };

  config = lib.mkIf config.custom.maomaowm.enable {
    programs = {
      maomaowm = {
        enable = true;
      };
    };
  };
}
