{lib, ...}: let
  inherit (lib) getExe;
in {
  flake.modules.homeManager.default = {
    pkgs,
    host,
    user,
    ...
  }: let
    # use the package configured by nvf
    customNeovim = pkgs.custom.nvf.override {
      inherit host;
      flakePath = "/persist/home/${user}/Projects/shirase";
    };
  in {
    home = {
      packages = [customNeovim];
      shellAliases = {
        nano = "nvim";
        neovim = "nvim";
        v = "nvim";
      };
    };

    xdg = {
      desktopEntries = {
        nvim = {
          name = "Neovim";
          genericName = "Text Editor";
          icon = "nvim";
          terminal = true;
          exec = getExe customNeovim;
        };
      };

      mimeApps = {
        defaultApplications = {
          "text/plain" = "nvim.desktop";
          "application/x-shellscript" = "nvim.desktop";
          "application/xml" = "nvim.desktop";
        };
        associations.added = {
          "text/csv" = "nvim.desktop";
        };
      };
    };

    custom.persist.home.directories = [
      ".local/share/nvim" # data directory
      ".local/state/nvim" # persistent session info
      ".supermaven"
      ".local/share/supermaven"
    ];
  };
}
