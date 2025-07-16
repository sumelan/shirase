{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      enable = true;
      wayland = if config.custom.maomao.enable then null else true;
      enabledExtensions = with spicePkgs.extensions; [
        # adblock
        keyboardShortcut
        copyToClipboard
        history
        betterGenres
        # lastfm
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
        historyInSidebar
      ];
      enabledSnippets = with spicePkgs.snippets; [
        circularAlbumArt
        newHoverPanel
        dynamicLeftSidebar
        spinningCdCoverArt
        pointer
      ];
      theme = spicePkgs.themes.bloom;
    };

  services.playerctld.enable = true;

  programs.niri.settings = {
    binds = {
      "Mod+S" = {
        action.spawn = lib.custom.niri.useUwsm (
          lib.concatStringsSep " " [
            "spotify"
            "--wayland-text-input-version=3"
          ]
        );
        hotkey-overlay.title = "<i>Launch</i> <b>spotify</b>";
      };
    };
    window-rules = [
      {
        matches = lib.singleton {
          app-id = "^(spotify)$";
        };
        default-column-width.proportion = 0.9;
      }
      {
        # mini player
        matches = lib.singleton {
          app-id = "^(chromium-browser)$";
        };
        open-floating = true;
      }
    ];
  };

  custom.persist = {
    home = {
      directories = [
        ".config/spotify"
      ];
      cache.directories = [
        ".cache/spotify"
      ];
    };
  };
  stylix.targets.spicetify.enable = false;
}
