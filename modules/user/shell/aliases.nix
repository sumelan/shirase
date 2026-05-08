_: {
  flake.custom.userModules.shellAliases = {
    basic = {
      # vim-like
      ":e" = "nvim";
      ":q" = "exit";
      ":wq" = "exit";

      aa = "echo (whoami)@(hostname)";
      c = "clear";
      ll = "ls -la";
      la = "ls -a";

      # cd aliases
      ".." = "cd ..";
      "..." = "cd ../..";

      cp = "cp -ri";
      mkdir = "mkdir -p";
      mount = "mount --mkdir";
      mime = "xdg-mime query filetype";
      open = "xdg-open";
      nv = "nvim";
    };
    extra = {
      cat = "bat -p";
      man = "batman";

      gst = "git status";
      ga = "git add";
      gaa = "git add *";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gf = "git fetch";
      grv = "git remote -v";
      lg = "lazygit";

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
