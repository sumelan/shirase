{
  pkgs,
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
      wayland = null;
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
