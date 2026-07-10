_: {
  flake.modules.nixos.syncthing = {
    config,
    user,
    ...
  }: let
    configDir = config.hjem.users.${user}.xdg.config.directory;
    dataDir = config.hjem.users.${user}.xdg.data.directory;

    music = "${config.hjem.users.${user}.directory}/Music";
    notes = "${config.hjem.users.${user}.directory}/Documents/Notes";
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
          "Notes" = {
            path = notes;
          };
          "Music" = {
            path = music;
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
