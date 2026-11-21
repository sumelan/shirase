{
  self,
  config,
  pkgs,
  customLib,
  ...
}: let
  inherit (pkgs.lib) genAttrs;
  inherit (customLib.niri) hotkey;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim;
in {
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs) wl-clipboard-rs;

      nvim = nvim.override {
        flake = "/persist/home/sumelan/Projects/shirase";
        inherit (config.networking) hostName;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  hjem.users.sumelan = {
    xdg.mime-apps = {
      default-applications = genAttrs [
        "text/plain"
        "application/x-shellscript"
        "application/xml"
      ] (_: "nvim.desktop");
      added-associations = genAttrs [
        "text/csv"
      ] (_: "nvim.desktop");
    };
  };

  custom = {
    wayland.windowManager.niri.extraBinds = {
      "Mod+Shift+Return" = {
        _props.hotkey-overlay-title = hotkey {
          color = "#a6d189";
          name = "  Neovim";
          desc = "Text Editor";
        };
        spawn = ["monstar" "--working-directory" "/persist/home/sumelan/Projects" "--app-id" "nvim" "-e" "nvim"];
      };
    };

    fileSystem = {
      persist.home.directories = [
        ".supermaven"
        ".local/share/nvim" # data directory
        ".local/state/nvim" # persistent session info
        ".local/share/supermaven"
      ];
    };
  };
}
