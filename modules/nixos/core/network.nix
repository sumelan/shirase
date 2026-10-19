{lib, ...}: {
  flake.modules.nixos.core = {
    config,
    pkgs,
    ...
  }: {
    # basic network settings
    networking = {
      networkmanager.enable = lib.mkDefault true;
      # firewall
      firewall.enable = true;
    };

    environment.systemPackages = lib.mkIf config.networking.networkmanager.enable [
      # NetworkManager control applet for GNOME
      pkgs.networkmanagerapplet
    ];
  };
}
