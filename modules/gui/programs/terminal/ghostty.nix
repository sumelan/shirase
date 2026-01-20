{lib, ...}: let
  inherit (lib) getExe mkForce;
in {
  flake.modules.homeManager.ghostty = {config, ...}: let
    monoFont = config.custom.fonts.monospace;
    fishPath = getExe config.programs.fish.package;
  in {
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        alpha-blending = "linear-corrected";
        confirm-close-surface = false;
        copy-on-select = "clipboard";
        cursor-style = "bar";
        font-family = monoFont;
        font-feature = "zero";
        font-size = 14;
        font-style = "Medium";
        minimum-contrast = 1.1;
        # run `ghostty +list-themes` to see available list
        theme = "Nord";
        window-decoration = false;
        command = mkForce "SHELL=${fishPath} ${fishPath}";
      };
    };
  };
}
