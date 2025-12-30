_: {
  flake = {
    modules = {
      nixos.default = {
        pkgs,
        host,
        ...
      }: {
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
        networking.firewall.enable = true;
      };
      homeManager.kdeconnect = {
        services.kdeconnect = {
          enable = true;
          indicator = true;
        };
        networking.firewall = let
          portRanges = {
            from = 1714;
            to = 1764;
          };
        in {
          allowedTCPPortRanges = portRanges;
          allowedUDPPortRanges = portRanges;
        };
      };
    };
    hm = {
      persist.home.directories = [".config/kdeconnect"];
      cache.home.directories = [
        ".cache/kdeconnect.app"
        ".cache/kdeconnect.daemon"
      ];
    };
  };
}
