{lib, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: {
    environment = {
      systemPackages = builtins.attrValues {
        inherit
          (pkgs)
          bonk # mkdir and touch in one
          curl
          dysk # better disk info
          ets # add timestamp to beginning of each line
          fd # better find
          fx # terminal json viewer and processor
          gzip
          htop
          jq
          just
          killall
          procs # better ps
          sd # better sed
          trash-cli
          ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
          xdg-utils
          ;
        inherit (lib.hiPrio pkgs) procps;
      };

      variables = {
        PAGER = "ov";
        SYSTEMD_PAGER = "ov";
        SYSTEMD_PAGERSECURE = "1";
        MANPAGER = ''ov --section-delimiter '^[^\s]' --section-header --sidebar-mode=sections'';
        TERMINAL = "foot";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
}
