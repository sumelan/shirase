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
    (lib.custom.niri)
    useUwsm
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
          action.spawn = useUwsm "spotify";
          hotkey-overlay.title = ''<span foreground="#f2d5cf">[Application]</span> spotify'';
        };
      };
      window-rules = [
        {
          matches = singleton {
            app-id = "^(spotify)$";
          };
          default-column-width.proportion = 0.9;
        }
        {
          # mini player
          matches = singleton {
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
  };
}
