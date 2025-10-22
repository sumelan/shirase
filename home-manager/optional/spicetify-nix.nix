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
      theme = spicePkgs.themes.ziro;
    };

    programs.niri.settings = {
      binds = {
        "Mod+S" = {
          action.spawn = ["spotify" "--wayland-text-input-version=3"];
          hotkey-overlay.title = ''<span foreground="#37f499">[Application]</span> Spotify'';
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
  };
}
