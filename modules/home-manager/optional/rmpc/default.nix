{
  lib,
  config,
  user,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    singleton
    ;
  inherit (lib.custom.colors) orange_base;
  inherit (lib.custom.niri) spawn hotkey;
in {
  imports = [
    ./config.nix
    ./theme.nix
  ];

  options.custom = {
    rmpc.enable =
      mkEnableOption "A beautiful and configurable TUI client for MPD";
  };

  config = mkIf config.custom.rmpc.enable {
    programs = {
      rmpc.enable = true;

      niri.settings = {
        binds = {
          "Mod+R" = {
            action.spawn = spawn "foot --app-id=rmpc rmpc";
            hotkey-overlay.title = hotkey {
              color = orange_base;
              name = "  rmpc";
              text = "Terminal MPD Client";
            };
          };
        };
        window-rules = [
          {
            matches = singleton {
              app-id = "^rmpc$";
            };
            open-floating = true;
            default-column-width.proportion = 0.35;
            default-window-height.proportion = 0.28;
          }
        ];
      };
    };

    systemd.user.tmpfiles.rules = [
      # symlink from rmpc cache to YouTube
      "L+ %h/Music/YouTube - - - - /persist/home/${user}/.cache/rmpc/youtube"
    ];

    custom.persist = {
      home.directories = [
        ".cache/rmpc/youtube"
      ];
    };
  };
}
