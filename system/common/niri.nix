{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

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

  # use gnome-polkit instead
  systemd.user.services.niri-flake-polkit.enable = false;
}
