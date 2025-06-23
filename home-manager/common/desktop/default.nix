{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./niri
    ./way-edges
    ./waybar
    ./discord.nix
    ./dunst.nix
    ./easyeffects.nix
    ./fuzzel.nix
    ./kitty.nix
    ./librewolf.nix
    ./mpv.nix
    ./nautilus.nix
    ./nixlogo.nix
    ./swayimg.nix
    ./swayosd.nix
    ./wallpaper.nix
    ./yazi.nix
  ];

  # NOTE: 'record-screeen' only works on single monitor setup
  home.packages =
    with pkgs;
    [
      wf-recorder
      slurp
      gifsicle
      zenity
    ]
    ++ [ self.packages.${pkgs.system}.desktop-scripts ];

  programs.niri.settings.binds =
    with config.lib.niri.actions;
    let
      ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
      toggleWidget = map (x: "way-edges togglepin " + x) [
        "workspace"
        "media"
        "slider"
        "stats"
      ];
    in
    {
      "Mod+Tab" = {
        action = ush (
          lib.concatStringsSep "; " (
            [
              "niri msg action toggle-overview"
              "${lib.getExe pkgs.killall} -SIGUSR1 .waybar-wrapped"
            ]
            ++ toggleWidget
          )
        );
        hotkey-overlay.title = "Open the Overview and Widgets";
      };
    };
}
