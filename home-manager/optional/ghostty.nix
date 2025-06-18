{ lib, config, ... }:
{

  options.custom = with lib; {
    ghostty = {
      enable = mkEnableOption "ghostty";
    };
  };

  config = lib.mkIf config.custom.ghostty.enable {
    programs = {
      ghostty = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        settings = {
          alpha-blending = "linear-corrected";
          background-opacity = config.stylix.opacity.terminal;
          confirm-close-surface = false;
          copy-on-select = "clipboard";
          # disable clipboard copy notifications temporarily until fixed upstream
          # https://github.com/ghostty-org/ghostty/issues/4800#issuecomment-2685774252
          app-notifications = "no-clipboard-copy";
          cursor-style = "bar";
          font-family = config.stylix.fonts.monospace.name;
          font-feature = "zero";
          font-size = config.stylix.fonts.sizes.terminal;
          font-style = "Medium";
          minimum-contrast = 1.1;
          window-decoration = false;
          window-padding-x = 12;
          window-padding-y = 12;
        };
      };

      niri.settings.binds =
        with config.lib.niri.actions;
        let
          ush = program: spawn "sh" "-c" "uwsm app -- ${program}";
        in
        {
          "Mod+Return" = {
            action = ush "ghostty";
            hotkey-overlay.title = "Ghostty";
          };
        };
    };
  };
}
