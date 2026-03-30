{lib, ...}: let
  inherit (builtins) attrValues;
  inherit (lib) hiPrio;
in {
  flake.modules = {
    nixos.default = {
      pkgs,
      user,
      ...
    }: {
      environment = {
        shellAliases = {
          ":e" = "nvim";
          ":q" = "exit";
          ":wq" = "exit";
          c = "clear";
          cat = "bat";
          ccat = "command cat";
          cp = "cp -ri";
          man = "batman";
          mime = "xdg-mime query filetype";
          mkdir = "mkdir -p";
          mount = "mount --mkdir";
          open = "xdg-open";
          sl = "ls";
          w = "watch -cn1 -x cat";
          coinfc = "pj coinfc";

          # cd aliases
          ".." = "cd ..";
          "..." = "cd ../..";
        };
        systemPackages = attrValues {
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
            microfetch
            procs # better ps
            sd # better sed
            trash-cli
            ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
            xdg-utils
            ;
          forUptime = hiPrio pkgs.procps;
        };

        variables = {
          TERMINAL = "foot";
          EDITOR = "nvim";
          VISUAL = "nvim";
          NIXPKGS_ALLOW_UNFREE = "1";
        };
      };

      # pj cannot be implemented as script as it needs to change the directory of the shell
      programs = let
        projects = "/persist/home/${user}/Projects";
      in {
        bash.shellInit =
          # sh
          ''
            function pj() {
                cd ${projects}
                if [[ $# -eq 1 ]]; then
                  cd "$1";
                fi
            }
            _pj() {
                ( cd ${projects}; printf "%s\n" "$2"* )
            }
            complete -o nospace -C _pj pj
          '';

        fish.shellInit =
          # fish
          ''
            function pj
              cd ${projects}
              if test (count $argv) -eq 1
                cd $argv[1]
              end
            end

            function _pj
                find ${projects} -maxdepth 1 -type d -exec basename {} \;
            end
            complete -c pj -f -a "(_pj)"
          '';
      };
    };

    homeManager.default = {pkgs, ...}: {
      home.packages = attrValues {
        inherit
          (pkgs)
          brightnessctl
          cliphist
          libnotify
          playerctl
          wl-clipboard
          ;
      };
    };
  };
}
