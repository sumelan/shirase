{lib, ...}: {
  flake.custom.hjemConfigs.mangowm = {
    config,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      wayland.windowManager.mango = let
        settings = import ./_config.nix {inherit config lib;};
        keybinds = import ./_keybinds.nix {};
      in {
        enable = true;
        inherit (config.programs.mango) package;
        topPrefixes = [];
        bottomPrefixes = [];
        autostart_sh =
          # sh
          ''
            waybar &
          '';
        settings = settings // keybinds;
        extraConfig = '''';
        systemd = {
          enable = true;
          extraCommands = [
            "systemctl --user reset-failed"
            "systemctl --user start mango-session.target"
          ];
          variables = [
            "DISPLAY"
            "WAYLAND_DISPLAY"
            "XDG_CURRENT_DESKTOP"
            "XDG_SESSION_TYPE"
            "NIXOS_OZONE_WL"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
          ];
          xdgAutostart = false;
        };
      };
    };
  };
}
