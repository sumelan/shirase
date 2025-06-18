{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  # HEIC image preview in Nautilus
  environment = {
    systemPackages = with pkgs; [
      libheif
      libheif.out
    ];
    pathsToLink = [ "share/thumbnailers" ];
  };

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    uwsm = {
      enable = true;
      waylandCompositors.niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = pkgs.writeShellScript "niri" ''
          ${lib.getExe config.programs.niri.package} --session
        '';
      };
    };
  };
  niri-flake.cache.enable = true;

  # https://github.com/YaLTeR/niri/wiki/Important-Software
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      niri."org.freedesktop.impl.portal.FileChooser" = "gtk";
      niri.default = "gnome";
      common.default = "gnome";
      obs.default = "gnome";
    };
  };

  # use gnome-polkit instead
  systemd.user.services.niri-flake-polkit.enable = false;
}
