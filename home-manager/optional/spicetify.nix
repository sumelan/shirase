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
        theme = spicePkgs.themes.nord;
        #  colorScheme = "custom";
        #  customColorScheme = with config.lib.stylix.colors; {
        #    text = base05;
        #    subtext = base04;
        #    main = base00;
        #    main-elevated = base01;
        #    main-transition = base01;
        #    highlight = base02;
        #    highlight-elevated = base00;
        #    sidebar = base01;
        #    player = base01;
        #    card = base03;
        #    shadow = base04;
        #    selected-row = base02;
        #    button = base0C;
        #    button-active = base0D;
        #    button-disabled = base03;
        #    tab-active = base02;
        #    notification = base06;
        #    notification-error = base08;
        #    misc = base04;
        #    play-button = base06;
        #    play-button-active = base0F;
        #    progress-fg = base02;
        #    progress-bg = base01;
        #    heart = base09;
        #    pagelink-active = base05;
        #    radio-btn-active = base0E;
        #  };
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
