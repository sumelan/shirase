_: {
  flake.modules.nixos.steam = _: {
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
    custom.fileSystem = {
      persist.home.directories = [".steam"];
      cache.home.directories = [
        ".local/share/Steam"
        ".cache/mesa_shader_cache"
        ".cache/mesa_shader_cache_db"
        ".cache/radv_builtin_shaders"
      ];
    };
  };
}
