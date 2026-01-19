_: {
  flake.modules.nixos = {
    default = {pkgs, ...}: {
      # system packages
      # NetworkManager control applet for GNOME
      environment.systemPackages = [pkgs.networkmanagerapplet];
      # basic network settings
      networking.networkmanager.enable = true;
      # firewall
      networking.firewall.enable = true;
    };

    kdeconnect = _: {
      programs.kdeconnect = {
        enable = true;
      };

      custom = {
        persist.home.directories = [
          ".config/kdeconnect"
        ];
        cache.home.directories = [
          ".cache/kdeconnect.app"
          ".cache/kdeconnect.daemon"
        ];
      };
    };
  };
}
