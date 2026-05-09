{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.rmpc = {pkgs, ...}: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) rmpc;

    # overwrite default desktop-entry
    rmpc-desktop-entry = pkgs.makeDesktopItem {
      name = "rmpc";
      desktopName = "rmpc";
      genericName = "Rusty Music Player Client";
      icon = "mpd";
      comment = "A modern, configurable, terminal based MPD Client with album art support.";
      terminal = true;
      tryExec = "rmpc";
      exec = "rmpc";
      type = "Application";
      categories = ["AudioVideo" "Audio" "Player" "Music" "ConsoleOnly"];
      keywords = ["Music" "Audio" "Player"];
    };
  in {
    hj = {
      packages = [
        rmpc
        (lib.hiPrio rmpc-desktop-entry)
      ];

      xdg.config.files."rmpc/config.ron".source = import ./_config.nix {inherit pkgs;};
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
