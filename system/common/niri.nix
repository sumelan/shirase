{
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  niri-flake.cache.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite # need for discord
  ];

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
  systemd.user.services.niri-flake-polkit.enable = false;
}
