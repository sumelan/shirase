{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.hjem-common = {
    config,
    pkgs,
    user,
    ...
  }: let
    homeDir = config.hjem.users.${user}.directory;
    xdg-user-dirs = {
      # xdg user dirs
      XDG_DESKTOP_DIR = "${homeDir}/Desktop";
      XDG_DOCUMENTS_DIR = "${homeDir}/Documents";
      XDG_DOWNLOAD_DIR = "${homeDir}/Downloads";
      XDG_MUSIC_DIR = "${homeDir}/Music";
      XDG_PICTURES_DIR = "${homeDir}/Pictures";
      XDG_PUBLICSHARE_DIR = "${homeDir}/Public";
      XDG_TEMPLATES_DIR = "${homeDir}/Templates";
      XDG_VIDEOS_DIR = "${homeDir}/Videos";
    };
  in {
    imports = builtins.attrValues flake.custom.hjemConfigs;

    environment.sessionVariables =
      {
        # xdg
        XDG_CACHE_HOME = config.hjem.users.${user}.xdg.cache.directory;
        XDG_CONFIG_HOME = config.hjem.users.${user}.xdg.config.directory;
        XDG_DATA_HOME = config.hjem.users.${user}.xdg.data.directory;
        XDG_STATE_HOME = config.hjem.users.${user}.xdg.state.directory;

        # stop libX11 from polluting $HOME with .compose-cache
        XCOMPOSECACHE = "${config.hjem.users.${user}.xdg.cache.directory}/xcompose";
      }
      // xdg-user-dirs;

    # modules standalone
    hjem.users.${user} = {
      packages = builtins.attrValues {
        # tools
        inherit (pkgs) brightnessctl libnotify wl-clipboard-rs playerctl hyperfine;
      };

      # misc
      xdg.config.files = {
        "user-dirs.conf".text = "enabled=False";
        "user-dirs.dirs" = {
          generator = lib.generators.toKeyValue {};
          # For some reason, these need to be wrapped with quotes to be valid.
          value = lib.mapAttrs (_: value: ''"${value}"'') xdg-user-dirs;
        };
      };
    };
  };
}
