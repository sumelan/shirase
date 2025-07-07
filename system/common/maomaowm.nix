{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.custom = {
    maomaowm.enable = lib.mkEnableOption "Enable maomaowm";
  };

  config = lib.mkIf config.custom.maomaowm.enable {
    programs = {
      maomaowm = {
        enable = true;
      };
      uwsm = {
        enable = true;
        waylandCompositors.maomaowm = {
          prettyName = "Maomaowm";
          comment = "Maomaowm managed by UWSM";
          binPath = lib.getExe inputs.maomaowm.packages."${pkgs.system}".default;
        };
      };
    };
  };
}
