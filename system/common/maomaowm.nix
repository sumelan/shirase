{
  lib,
  config,
  pkgs,
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
      uwsm = lib.mkIf config.custom.maomaowm.uwsm.enable {
        enable = true;
        waylandCompositors.maomaowm = {
          prettyName = "Maomaowm";
          comment = "Maomaowm managed by UWSM";
          binPath = pkgs.writeShellScript "maomaowm" ''
            ${lib.getExe' inputs.maomaowm.packages.${pkgs.system}.default "maomao"} 
          '';
        };
      };
    };
  };
}
