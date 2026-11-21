{
  self,
  pkgs,
  customLib,
  ...
}: let
  inherit (customLib.niri) hotkey;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) monstar;
in {
  hjem.users.sumelan = {
    packages = [
      monstar
    ];

    xdg.mime-apps.default-applications = {
      "x-scheme-handler/terminal" = "dev.rockorager.monstar.desktop";
    };
  };

  environment.sessionVariables = {
    TERMINAL = "monstar";
  };

  # fix opening terminal for nautilus by using xdg-terminal-exec spec
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = ["dev.rockorager.monstar.desktop"];
    };
  };

  custom.wayland.windowManager.niri.extraBinds = {
    "Mod+Return" = {
      _props.hotkey-overlay-title = hotkey {
        color = "#f4b8e4";
        name = "  Monstar";
        desc = "Terminal Emulator";
      };
      spawn = ["monstar"];
    };
  };
}
