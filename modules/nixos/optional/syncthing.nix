{
  lib,
  config,
  user,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    syncthing.enable = mkEnableOption "syncthing";
  };

  config = mkIf config.custom.syncthing.enable {
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

      configDir = "/home/${user}/.config/syncthing";
      dataDir = "/home/${user}/.local/state/syncthing";

      guiPasswordFile = config.sops.secrets."syncthing/gui-password".path;

      settings = {
        gui = {
          inherit user;
          theme = "dark";
        };
        folders = {
          "Documents" = {
            path = "/home/${user}/Documents";
          };
          "Music" = {
            path = "/home/${user}/Music";
          };
          "Playlist" = {
            path = "/home/${user}/.local/share/mpd/playlists";
          };
          "Wallpapers" = {
            path = "/home/${user}/Pictures/Wallpapers";
          };
        };
      };
    };

    custom.persist = {
      home.directories = [
        ".local/state/syncthing"
      ];
    };
  };
}
