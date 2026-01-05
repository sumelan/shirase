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

    valent = {pkgs, ...}: {
      programs.kdeconnect = {
        enable = true;
        package = pkgs.valent;
      };

      custom = {
        persist.home.directories = [".config/valent"];
        cache.home.directories = [
          ".cache/valent"
        ];
      };
    };
  };
}
