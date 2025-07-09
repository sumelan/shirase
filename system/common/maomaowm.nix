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
      enable = lib.mkEnableOption "Enable maomaowm" // {
        default = true;
      };
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
