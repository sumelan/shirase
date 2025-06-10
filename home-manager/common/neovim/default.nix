{ config, user, ... }:
{
  imports = [
    ./keymaps.nix
    ./nvf.nix
  ];

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

  programs.niri.settings = {
    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      {
        # neovim
        "Mod+Shift+Return" = {
          action = sh "cd /home/${user}/projects/wolborg && ${config.custom.terminal.exec} --app-id neovim nvim";
          hotkey-overlay.title = "Edit Config";
        };
      };
    window-rules = [
      {
        # Mod+C launch cava with app-id
        matches = [ { app-id = "^(neovim)$"; } ];
        default-column-width.proportion = 0.8;
        default-window-height.proportion = 0.8;
        open-floating = true;
      }
    ];
  };

  custom.persist = {
    home.directories = [
      ".local/share/nvim" # data directory
      ".local/state/nvim" # persistent session info
      ".supermaven"
      ".local/share/supermaven"
    ];
  };
}
