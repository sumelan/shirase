_: {
  flake.modules.nixos.steam = {
    config,
    pkgs,
    user,
    ...
  }: {
    programs.steam = let
      home = config.hjem.users.${user}.directory;
      cacheHome = "/cache" + home;
      cursorPath = "${pkgs.kdePackages.breeze}/share/icons/breeze_cursors";
    in {
      enable = true;
      package = pkgs.steam.override {
        # get rid of ~/.steam directory:
        # https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
        extraBwrapArgs = [
          "--bind ${cacheHome} $HOME"
          "--unsetenv XDG_CONFIG_HOME"
          "--unsetenv XDG_CACHE_HOME"
          "--unsetenv XDG_DATA_HOME"
          "--unsetenv XDG_STATE_HOME"
          "--symlink ${cursorPath} ${cacheHome}/.local/share/icons/default"
        ];
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
