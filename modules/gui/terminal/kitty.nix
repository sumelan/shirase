{lib, ...}: let
  inherit (lib) getExe mkForce;
in {
  flake.modules.homeManager.default = {config, ...}: let
    inherit (config.custom.fonts) monospace;
    fishPath = getExe config.programs.fish.package;
  in {
    programs.kitty = {
      enable = true;
      shellIntegration = {
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
      enableGitIntegration = true;
      themeFile = "Nord";
      font = {
        name = monospace;
        size = 14;
      };
      settings = {
        env = "SHELL=${fishPath}";
        shell = mkForce fishPath;
        enable_audio_bell = false;
        copy_on_select = "clipboard";
        cursor_trail = 3;
        cursor_trail_start_threshold = 10;
        scrollback_lines = 10000;
        update_check_interval = 0;
        window_padding_width = 1;
        background_opacity = 1.0;
        tab_bar_edge = "top";
        confirm_os_window_close = 0;
        # for removing kitty padding when in neovim
        placement_strategy = "top";
        allow_remote_control = "password";
        remote_control_password = ''"" set-spacing''; # only allow setting of padding
        listen_on = "unix:/tmp/kitty-socket";
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };

    home.shellAliases = {
      # change color on ssh
      ssh = "kitten ssh --kitten=color_scheme='Rosé Pine Moon'";
    };
  };
}
