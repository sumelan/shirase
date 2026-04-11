{lib, ...}: let
  inherit (lib) mkDefault hiPrio;
in {
  flake.wrappers.rmpc = {
    config,
    wlib,
    ...
  }: {
    imports = [wlib.modules.default];

    config.package = mkDefault config.pkgs.rmpc;
    # TODO: add `--config` flags after v0.12 released
    config.flags = {
      "--theme" = import ./_theme.nix {inherit config;};
    };
  };

  flake.modules.nixos.mpd = {
    config,
    pkgs,
    ...
  }: let
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
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) rmpc;
      })
    ];

    hj = {
      packages = [
        pkgs.rmpc # overlay-ed above
        (hiPrio rmpc-desktop-entry)
      ];

      xdg.config.files."rmpc/config.ron".source = import ./_config.nix {inherit config pkgs;};
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
