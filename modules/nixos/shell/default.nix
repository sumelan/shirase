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
        PAGER = "ov -F -H3";
        SYSTEMD_PAGER = "ov";
        MANPAGER = ''ov --section-delimiter '^[^\s]' --section-header --sidebar-mode=sections'';
        SYSTEMD_PAGERSECURE = "1";
        TERMINAL = "foot";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
}
