{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    ;
in {
  options.custom = {
    niri = {
      enable =
        mkEnableOption "Niri compositor" // {default = true;};
      uwsm.enable =
        mkEnableOption "Uing uwsm with niri" // {default = config.custom.niri.enable;};
    };
  };

  config = mkIf config.custom.niri.enable {
    nixpkgs.overlays = [inputs.niri.overlays.niri];
    programs = {
      niri = {
        enable = true;
        package = pkgs.niri-unstable;
      };
      uwsm = mkIf config.custom.niri.uwsm.enable {
        enable = true;
        waylandCompositors.niri = {
          prettyName = "Niri";
          comment = "Niri compositor managed by UWSM";
          # https://github.com/YaLTeR/niri/issues/254
          binPath = pkgs.writeShellScript "niri" ''
            ${getExe config.programs.niri.package} --session
          '';
        };
      };
    };
    niri-flake.cache.enable = true;
    # use gnome-polkit instead
    systemd.user.services.niri-flake-polkit.enable = false;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = builtins.attrValues {
        inherit
          (pkgs)
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
          ;
      };

      config = {
        common.default = ["gnome"];
        niri = {
          default = "gnome";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
        obs.default = ["gnome"];
      };
    };
  };
}
