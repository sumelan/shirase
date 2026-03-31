{lib, ...}: let
  inherit (lib) getExe hiPrio;
in {
  flake.modules.nixos.hjem-rmpc = {
    config,
    pkgs,
    ...
  }: let
    rmpc-desktop-entry = pkgs.makeDesktopItem {
      name = "rmpc";
      desktopName = "Rusty Music Player Client";
      genericName = "Terminal based Music Player Daemon client";
      icon = "mpd";
      terminal = true;
      exec = getExe pkgs.rmpc;
    };
  in {
    hj = {
      packages = [
        pkgs.rmpc
        (hiPrio rmpc-desktop-entry)
      ];

      xdg.config.files = {
        "rmpc/config.ron".source = import ./_config.nix {inherit config pkgs;};
        "rmpc/themes/custom.ron".source = import ./_theme.nix {inherit pkgs;};
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
