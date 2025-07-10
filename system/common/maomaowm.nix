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
    maomao = {
      enable = lib.mkEnableOption "Enable maomaowm";
    };
  };

  config = lib.mkIf config.custom.maomao.enable {
    programs = {
      maomaowm = {
        enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      config = {
        common = {
          default = "wlr";
        };
      };
    };
  };
}
