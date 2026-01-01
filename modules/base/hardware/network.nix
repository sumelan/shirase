_: {
  flake.modules = {
    nixos.default = {pkgs, ...}: {
      # system packages
      # NetworkManager control applet for GNOME
      environment.systemPackages = [pkgs.networkmanagerapplet];
      # basic network settings
      networking.networkmanager.enable = true;
      # firewall
      networking.firewall = let
        portRanges = {
          from = 1714;
          to = 1764;
        };
      in {
        enable = true;
        # kdeconnect port
        allowedTCPPortRanges = [portRanges];
        allowedUDPPortRanges = [portRanges];
      };
    };
    homeManager.kdeconnect = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
      custom = {
        persist.home.directories = [".config/kdeconnect"];
        cache.home.directories = [
          ".cache/kdeconnect.app"
          ".cache/kdeconnect.daemon"
        ];
      };
    };
  };
}
