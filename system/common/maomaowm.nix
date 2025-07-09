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
