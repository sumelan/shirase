{
  lib,
  config,
  ...
}:
{
  networking.firewall = lib.mkIf config.custom.audiobookshelf.nginx.enable {
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
