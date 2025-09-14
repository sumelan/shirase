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
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  options.custom = {
    spotify.enable = mkEnableOption "Spotify";
  };

  config = mkIf config.custom.spotify.enable {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in {
      enable = true;
      wayland = true;
      enabledExtensions = with spicePkgs.extensions; [
        keyboardShortcut
        betterGenres
        hidePodcasts
        playlistIcons
        shuffle
      ];
      enabledCustomApps = with spicePkgs.apps; [newReleases];
      enabledSnippets = with spicePkgs.snippets; [
        hideSidebarScrollbar
        newHoverPanel
        removeConnectBar
      ];
      theme = spicePkgs.themes.orchis;
    };

    programs.niri.settings = {
      binds = {
        "Mod+S" = {
          action.spawn = ["sh" "-c" "uwsm app -- spotify"];
          hotkey-overlay.title = ''<span foreground="${config.lib.stylix.colors.withHashtag.base0B}">[Application]</span> Spotify'';
        };
      };
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
