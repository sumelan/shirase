{
  config,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (config) flake;
in {
  flake.modules = {
    nixos.default = {pkgs, ...}: let
      # use the package configured by nvf
      customNeovim = flake.packages.${pkgs.stdenv.hostPlatform.system}.nvf;
    in {
      environment.systemPackages = [customNeovim];
    };

    homeManager.default = {pkgs, ...}: let
      # use the package configured by nvf
      customNeovim = flake.packages.${pkgs.stdenv.hostPlatform.system}.nvf;
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
  };
}
