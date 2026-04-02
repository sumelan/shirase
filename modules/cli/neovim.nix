{lib, ...}: let
  inherit (lib) getExe hiPrio;
in {
  flake.modules.nixos = {
    default = {pkgs, ...}: {
      environment = {
        systemPackages = [pkgs.custom.nvf];
        shellAliases = {
          nano = "nvim";
          neovim = "nvim";
          v = "nvim";
        };
      };
    };

    hjem-default = {pkgs, ...}: let
      nvim-direnv = pkgs.writeShellApplication {
        name = "nvim-direnv";
        runtimeInputs = [pkgs.direnv];
        text =
          # sh
          ''
            if ! direnv exec "$(dirname "$1")" nvim "$@"; then
                nvim "$@"
            fi
          '';
      };
      nvim-desktop-entry = pkgs.makeDesktopItem {
        name = "nvim";
        desktopName = "Neovim";
        genericName = "Text Editor";
        icon = "nvim";
        terminal = true;
        exec = "${getExe nvim-direnv} %F";
      };
    in {
      hj = {
        packages = [
          pkgs.custom.nvf
          (hiPrio nvim-desktop-entry)
        ];
        xdg.mime-apps = {
          default-applications = {
            "text/plain" = "nvim.desktop";
            "application/x-shellscript" = "nvim.desktop";
            "application/xml" = "nvim.desktop";
          };
          added-associations = {
            "text/csv" = "nvim.desktop";
          };
        };
      };

      custom.fileSystem = {
        persist.home.directories = [
          ".local/share/nvim" # data directory
          ".local/state/nvim" # persistent session info
          ".supermaven"
          ".local/share/supermaven"
        ];
      };
    };
  };
}
