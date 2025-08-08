{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.mango.nixosModules.mango];

  options.custom = {
    mango = {
      enable = lib.mkEnableOption "Wayland compositor base wlroots and scenefx(dwl but no suckless)";
    };
  };

  config = lib.mkIf config.custom.mango.enable {
    programs = {
      mango = {
        enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr = {
        enable = true;
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        mango = {
          default = [
            "gtk"
            "wlr"
          ];
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
    };
  };
}
