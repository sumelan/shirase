_: {
  flake.modules.nixos.core = {pkgs, ...}: {
    # system packages
    # NetworkManager control applet for GNOME
    environment.systemPackages = [pkgs.networkmanagerapplet];
    # basic network settings
    networking.networkmanager.enable = true;
    # firewall
    networking.firewall.enable = true;
  };
}
