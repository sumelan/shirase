{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkDefault
    mkIf
    ;
in {
  # basic network settings
  networking = {
    networkmanager.enable = mkDefault true;
    # firewall
    firewall.enable = true;
  };

  environment.systemPackages = mkIf config.networking.networkmanager.enable [
    # NetworkManager control applet for GNOME
    pkgs.networkmanagerapplet
  ];
}
