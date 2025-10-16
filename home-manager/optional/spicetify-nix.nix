{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
  inherit
    (config.lib.stylix.colors.withHashtag)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base08
    base09
    base0C
    base0D
    base0E
    base0F
    ;
in {
  options.custom = {
    spicetify-nix.enable = mkEnableOption "Spotify";
  };

  config = mkIf config.custom.spicetify-nix.enable {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in {
      enable = true;
      wayland = true;
      enabledExtensions = builtins.attrValues {
        inherit
          (spicePkgs.extensions)
          keyboardShortcut
          betterGenres
          hidePodcasts
          playlistIcons
          shuffle
          ;
      };
      enabledCustomApps = builtins.attrValues {
        inherit
          (spicePkgs.apps)
          newReleases
          ;
      };
      enabledSnippets = builtins.attrValues {
        inherit
          (spicePkgs.snippets)
          hideSidebarScrollbar
          newHoverPanel
          removeConnectBar
          ;
      };
      theme = spicePkgs.themes.comfy;
      colorScheme = "custom";
      customColorScheme = {
        text = base05;
        subtext = base04;
        main = base00;
        main-elevated = base01;
        main-transition = base01;
        highlight = base02;
        highlight-elevated = base00;
        sidebar = base01;
        player = base01;
        card = base03;
        shadow = base04;
        selected-row = base02;
        button = base0C;
        button-active = base0D;
        button-disabled = base03;
        tab-active = base02;
        notification = base06;
        notification-error = base08;
        misc = base04;
        play-button = base06;
        play-button-active = base0F;
        progress-fg = base02;
        progress-bg = base01;
        heart = base09;
        pagelink-active = base05;
        radio-btn-active = base0E;
      };
    };

    programs.niri.settings = {
      window-rules = [
        {
          # mini player
          matches = singleton {
            app-id = "^(chromium-browser)$";
          };
          open-floating = true;
          opacity = 1.0;
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
  };
}
