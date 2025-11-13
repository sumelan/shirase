{
  lib,
  config,
  pkgs,
  host,
  user,
  ...
}: let
  inherit (lib) optional;
in {
  networking = {
    # Define your hostname
    hostName = host;
    # Enable networking
    networkmanager.enable = true;

    firewall = let
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
  };

  environment.systemPackages = [
    # NetworkManager control applet for GNOME
    pkgs.networkmanagerapplet
  ];

  programs.wireshark = {
    inherit (config.hm.custom.wifi) enable;
    package = pkgs.wireshark; # default: wireshark-cli
  };

  users.users.${user}.extraGroups = optional config.hm.custom.wifi.enable "wireshark";
}
