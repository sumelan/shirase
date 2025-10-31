{
  lib,
  pkgs,
  host,
  flakePath,
  ...
}: let
  inherit (lib) getExe;

  # use the package configured by nvf
  customNeovim = pkgs.custom.nvf.override {inherit host flakePath;};
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
}
