{ lib, config, ... }:
{
  imports = [
    ./keymaps.nix
    ./nvf.nix
  ];

  options.custom = {
    neovim.enable = lib.mkEnableOption "neovim editor" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.neovim.enable {
    programs.neovim.enable = true;
    home.shellAliases = {
      nano = "nvim";
      neovim = "nvim";
      v = "nvim";
    };

    xdg = {
      desktopEntries.nvim = {
        name = "Neovim";
        genericName = "Text Editor";
        icon = "nvim";
        terminal = true;
        exec = "nvim";
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

    custom.persist = {
      home.directories = [
        ".local/share/nvim" # data directory
        ".local/state/nvim" # persistent session info
        ".supermaven"
        ".local/share/supermaven"
      ];
    };
  };
}
