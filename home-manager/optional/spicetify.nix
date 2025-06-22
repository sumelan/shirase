{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.custom = with lib; {
    spotify.enable = mkEnableOption "spotify client to improve user experience" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.spotify.enable {
    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        wayland = true;
        enabledExtensions = with spicePkgs.extensions; [
          # adblock
          hidePodcasts
          shuffle # shuffle+ (special characters are sanitized out of extension names)
        ];
        enabledCustomApps = with spicePkgs.apps; [
          newReleases
          ncsVisualizer
        ];
        enabledSnippets = with spicePkgs.snippets; [
          rotatingCoverart
          pointer
        ];
        theme = spicePkgs.themes.bloom;
      };

    services.playerctld.enable = true;

    programs.niri.settings = {
      binds =
        with config.lib.niri.actions;
        let
          ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
        in
        {
          "Mod+S" = {
            action = ush "spotify";
            hotkey-overlay.title = "Spotify";
          };
        };
      window-rules = [
        {
          matches = [ { app-id = "^(Spotify Premium)$"; } ];
          default-column-width.proportion = 0.9;
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
