{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
# NOTE When installing niri by this flake:
# - The niri package will be installed, including its systemd units and the niri-session binary.
# - xdg-desktop-portal-gnome will be installed, as it is necessary for screencasting.
# - The GNOME keyring will be enabled. You probably want a keyring installed.
# - It will enable polkit, and run the KDE polkit agent.
# - - If you prefer a different polkit authentication agent, you can set systemd.user.services.niri-flake-polkit.enable = false;
# - It enables various other features that Wayland compositors may need, such as dconf, opengl and default fonts. It also adds a pam entry for swaylock, which is necessary if you wish to use swaylock.
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = lib.mkIf config.hm.custom.niri.enable {
    enable = true;
    package = pkgs.niri-unstable;
  };
  niri-flake.cache.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    brightnessctl
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
  systemd.user.services.niri-flake-polkit.enable = false;
}
