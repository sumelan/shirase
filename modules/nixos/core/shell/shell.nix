{
  self,
  pkgs,
  ...
}: {
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
        killall
        procs # better ps
        sd # better sed
        trash-cli
        ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
        xdg-utils
        ;
      inherit (pkgs.lib.hiPrio pkgs) procps;
      inherit
        (self.packages.${pkgs.stdenv.hostPlatform.system})
        just
        ;
    };

    variables = {
      PAGER = "moor";
      SYSTEMD_PAGER = "moor";
      SYSTEMD_PAGERSECURE = "1";
      MANPAGER = ''moor'';
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
}
