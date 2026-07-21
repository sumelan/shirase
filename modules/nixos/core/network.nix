_: {
  flake.modules.nixos.core = {pkgs, ...}: {
    environment.systemPackages = [
      # NetworkManager control applet for GNOME
      pkgs.networkmanagerapplet
    ];
    # basic network settings
    networking.networkmanager.enable = true;
    # firewall
    networking.firewall.enable = true;
  };
}
