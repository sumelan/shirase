{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
  inherit (lib.custom.colors) green_base;
  inherit (lib.custom.niri) spawn hotkey;
in {
  options.custom = {
    spicetify-nix.enable = mkEnableOption "Spotify";
  };

  config = mkIf config.custom.spicetify-nix.enable {
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
      theme = spicePkgs.themes.ziro;
    };

    programs.niri.settings = {
      binds = {
        "Mod+S" = {
          action.spawn = spawn "spotify";
          hotkey-overlay.title = hotkey {
            color = green_base;
            name = "  Spotify";
            text = "Spotify Client";
          };
        };
      };

      window-rules = [
        {
          # mini player
          matches = singleton {
            app-id = "^chromium-browser$";
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
  };
}
