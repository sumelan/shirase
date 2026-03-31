_: {
  flake.modules.nixos.syncthing = {
    config,
    user,
    ...
  }: let
    configDir = config.hj.xdg.config.directory;
    cacheDir = config.hj.xdg.cache.directory;
    dataDir = config.hj.xdg.data.directory;
    documents = "${config.hj.directory}/Documents";
    music = "${config.hj.directory}/Music";
    pictures = "${config.hj.directory}/Pictures";
    videos = "${config.hj.directory}/Videos";
  in {
    # port 8384  is the default port to allow access from the network
    networking.firewall.allowedTCPPorts = [8384];

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      # Override all settings set from the GUI
      overrideDevices = true;
      overrideFolders = true;

      # NOTE: by default, syncthing creates user `syncthing` so no perm outside `/var/lib/syncthing`
      inherit user;
      inherit (config.users.users.${user}) group;

      configDir = "${configDir}/syncthing";
      dataDir = "${dataDir}/syncthing";

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
          "Pictures" = {
            path = pictures;
          };
          "Videos" = {
            path = videos;
          };
          "MPD" = {
            path = "${dataDir}/mpd";
          };
          "Youtube" = {
            path = "${dataDir}/youtube-tui";
          };
          "Euphonica" = {
            path = "${cacheDir}/euphonica";
          };
        };
      };
    };
    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/syncthing"
      ];
    };
  };
}
