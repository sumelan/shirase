{
  lib,
  config,
  pkgs,
  host,
  user,
  ...
}: let
  inherit (lib) mkIf mkMerge;
in
  mkMerge [
    {
      networking = {
        # Define your hostname
        hostName = host;
        # Enable networking
        networkmanager.enable = true;
        firewall.enable = true;
      };
      environment.systemPackages = [
        # NetworkManager control applet for GNOME
        pkgs.networkmanagerapplet
      ];
    }
    (mkIf config.hm.custom.wifi.enable {
      programs.wireshark = {
        enable = true;
        package = pkgs.wireshark; # default: wireshark-cli
      };
      users.users.${user}.extraGroups = ["wireshark"];
    })
    (mkIf config.hm.custom.kdeconnect.enable {
      networking.firewall = rec {
        allowedTCPPortRanges = [
          {
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = allowedTCPPortRanges;
      };
    })
  ]
