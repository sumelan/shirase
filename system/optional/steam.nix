{ lib, config, ... }:
{
  options.custom = {
    steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.custom.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    hardware = {
      graphics.enable32Bit = true;
      amdgpu.amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
    };

    custom.persist = {
      home.directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };
}
