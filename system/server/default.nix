{
  lib,
  config,
  ...
}:
{
  imports = [
    ./audiobookshelf.nix
    ./nextcloud.nix
    ./nginx.nix
  ];
  
  networking.firewall= lib.mkIf config.custom.nginx.enable {
    allowedTCPPorts = [
      80
      443
      59010
      59011
    ];
    allowedUDPPorts = [
      59010
      59011
    ];
  };
}
