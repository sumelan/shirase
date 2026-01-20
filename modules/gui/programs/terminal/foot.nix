{lib, ...}: let
  inherit (lib) getExe mkForce;
in {
  flake.modules = {
    nixos.default = {config, ...}: let
      inherit (config.hm.custom.fonts) monospace;
      fishPath = getExe config.hm.programs.fish.package;
    in {
      programs.foot = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
        theme = "nord";
        settings = {
          main = {
            font = "${monospace}:size=14";
            initial-window-size-pixels = "1000x800";
            shell = mkForce fishPath;
          };
          scrollback = {
            lines = 100000;
          };
          cursor = {
            style = "beam";
            blink = "yes";
            blink-rate = 500;
            beam-thickness = 2.0;
          };
          mouse = {
            hide-when-typing = "yes";
          };
          environment = {
            "SHELL" = fishPath;
          };
        };
      };
    };
    homeManager.default = _: {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/terminal" = "foot.desktop";
      };
    };
  };
}
