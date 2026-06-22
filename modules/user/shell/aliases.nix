_: {
  flake.custom.userModules.shellAliases = {
    basic = {
      # vim-like
      ":e" = "hx";
      ":q" = "exit";
      ":wq" = "exit";

      aa = "echo (whoami)@(hostname)";
      c = "clear";

      # cd aliases
      ".." = "cd ..";
      "..." = "cd ../..";

      # neovim
      nv = "nvim";
    };
    extra = {
      lt = "eza --tree --level=2 --icons";
      tree = "eza --tree";
      cat = "bat -p";

      # git
      gst = "git status";
      ga = "git add";
      gaa = "git add *";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gf = "git fetch";
      grv = "git remote -v";
      lg = "lazygit";

      # zfs
      zls = "zfs list -o name,used,compressratio,lused,avail";
      zsls = "zfs list -t snapshot -S creation -o name,creation,used,written,refer";
    };

    fish = {
      ll = "eza -ala -g --icons";
      la = "eza -A";
      duz = "du -xh . | sort -hr | fzf";
      n = "nu -c";
    };

    nu = {
      ll = "ls -la";
      la = "ls -a";
      fg = "job unfreeze";
    };
  };
}
