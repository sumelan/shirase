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
  options.custom = {
    spotify.enable = mkEnableOption "Spotify";
  };

  config = mkIf config.custom.spotify.enable {
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
      theme = spicePkgs.themes.orchis;
    };

    programs.niri.settings = {
      binds = {
        "Mod+S" = {
          action.spawn = ["sh" "-c" "uwsm app -- spotify --wayland-text-input-version=3"];
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
