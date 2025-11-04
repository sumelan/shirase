{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    steam.enable =
      mkEnableOption "steam"
      // {
        default = config.hm.custom.niri.xwayland.enable;
      };
  };

  config = mkIf config.custom.steam.enable {
    # To get Steam games working with monado on NixOS,
    # use below as launch options on steam and, if prompted, choose the SteamVR launch option.
    # env PRESSURE_VESSEL_FILESYSTEMS_RW=$XDG_RUNTIME_DIR/monado_comp_ipc %command%
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    hardware = {
      graphics.enable32Bit = true;
    };

    custom.persist = {
      home.directories = [
        ".steam"
        ".local/share/Steam"
      ];
    };
  };
}
