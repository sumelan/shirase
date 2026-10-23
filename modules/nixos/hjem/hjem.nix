{
  inputs,
  config,
  pkgs,
  ...
}: let
  homeDir = config.hjem.users.sumelan.directory;
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
  environment.sessionVariables =
    {
      # xdg
      XDG_CACHE_HOME = config.hjem.users.sumelan.xdg.cache.directory;
      XDG_CONFIG_HOME = config.hjem.users.sumelan.xdg.config.directory;
      XDG_DATA_HOME = config.hjem.users.sumelan.xdg.data.directory;
      XDG_STATE_HOME = config.hjem.users.sumelan.xdg.state.directory;

      # stop libX11 from polluting $HOME with .compose-cache
      XCOMPOSECACHE = "${config.hjem.users.sumelan.xdg.cache.directory}/xcompose";
    }
    // xdg-user-dirs;

  hjem = {
    clobberByDefault = true;
    extraModules = [
      (inputs.import-tree ./extraModules)
    ];

    users.sumelan = {
      user = "sumelan";
      directory = "/home/sumelan";

      xdg.config.files = {
        "user-dirs.conf".text = "enabled=False";
        "user-dirs.dirs" = {
          generator = pkgs.lib.generators.toKeyValue {};
          # For some reason, these need to be wrapped with quotes to be valid.
          value = pkgs.lib.mapAttrs (_: value: ''"${value}"'') xdg-user-dirs;
        };
      };
    };
  };
}
