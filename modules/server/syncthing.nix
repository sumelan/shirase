_: {
  flake.modules.nixos.syncthing = {
    config,
    user,
    ...
  }: {
    # port 8384  is the default port to allow access from the network
    networking.firewall.allowedTCPPorts = [8384];

    services.syncthing = let
      inherit (config.hm.xdg) configHome cacheHome dataHome;
      inherit (config.hm.xdg.userDirs) documents music pictures;
      mpdData = "${dataHome}/mpd";
    in {
      enable = true;
      openDefaultPorts = true;
      # Override all settings set from the GUI
      overrideDevices = true;
      overrideFolders = true;

      # NOTE: by default, syncthing creates user `syncthing` so no perm outside `/var/lib/syncthing`
      inherit user;
      inherit (config.users.users.${user}) group;

      configDir = "${configHome}/syncthing";
      dataDir = "${dataHome}/syncthing";

      guiPasswordFile = config.sops.secrets."syncthing/gui-password".path;

      settings = {
        gui = {
          inherit user;
          theme = "dark";
        };
        folders = {
          "Documents" = {
            path = documents;
          };
          "Music" = {
            path = music;
          };
          "MPD" = {
            path = mpdData;
          };
          "Euphonica" = {
            path = "${cacheHome}/euphonica";
          };
          "Wallpapers" = {
            path = "${pictures}/Wallpapers";
          };
        };
      };
    };
    custom.persist.home.directories = [
      ".local/share/syncthing"
    ];
  };
}
