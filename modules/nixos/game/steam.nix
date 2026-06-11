_: {
  flake.modules.nixos.steam = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = [
      pkgs.adwsteamgtk
    ];

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        # get rid of ~/.steam directory:
        # https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
        extraBwrapArgs = [
          "--bind /persist/${config.hj.directory} $HOME"
          "--unsetenv XDG_CACHE_HOME"
          "--unsetenv XDG_CONFIG_HOME"
          "--unsetenv XDG_DATA_HOME"
          "--unsetenv XDG_STATE_HOME"
        ];
        # Disabling hardware acceleration allows it to work more consistently such as on niri
        extraArgs = "-cef-disable-gpu -cef-disable-gpu-compositing";
      };
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    hardware = {
      graphics.enable32Bit = true;
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".local/share/applications" # desktop files from steam
        ".local/share/icons/hicolor" # icons from steam
        ".local/share/Steam"
        ".cache/mesa_shader_cache"
        ".cache/mesa_shader_cache_db"
        ".cache/radv_builtin_shaders"
      ];
    };
  };
}
