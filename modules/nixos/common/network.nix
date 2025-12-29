{
  config,
  lib,
  pkgs,
  host,
  user,
  ...
}: let
  inherit (lib) optional;
in {
  # system packages
  # NetworkManager control applet for GNOME
  environment.systemPackages = [pkgs.networkmanagerapplet];
  # basic network settings
  networking = {
    # Enable networking
    networkmanager.enable = true;
    # Define your hostname
    hostName = host;
  };
  # firewall
  networking.firewall = let
    portRanges = {
      from = 1714;
      to = 1764;
    };
  in {
    enable = true;
    allowedTCPPortRanges =
      optional config.hm.custom.kdeconnect.enable
      portRanges;
    allowedUDPPortRanges =
      optional config.hm.custom.kdeconnect.enable
      portRanges;
  };
  # wireshark
  programs.wireshark = {
    inherit (config.hm.custom.wifi) enable;
    package = pkgs.wireshark; # default value: wireshark-cli
  };
  users.users.${user}.extraGroups = optional config.hm.custom.wifi.enable "wireshark";
}
