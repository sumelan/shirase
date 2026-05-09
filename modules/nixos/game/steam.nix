_: {
  flake.modules.nixos.steam = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.adwsteamgtk
    ];

    programs.steam = {
      enable = true;
      # Disabling hardware acceleration allows it to work more consistently such as on niri
      package = pkgs.steam.override {extraArgs = "-cef-disable-gpu -cef-disable-gpu-compositing";};
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
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
