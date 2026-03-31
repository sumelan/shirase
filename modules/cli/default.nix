{lib, ...}: let
  inherit (builtins) attrValues;
  inherit (lib) hiPrio mapAttrs;
  inherit (lib.generators) toKeyValue;
in {
  flake.modules.nixos = {
    default = {
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
            just
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
          TERMINAL = "kitty";
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

    hjem-default = {
      config,
      pkgs,
      ...
    }: let
      homeDir = config.hj.directory;
      xdg-user-dirs = {
        # xdg user dirs
        XDG_DESKTOP_DIR = "${homeDir}/Desktop";
        XDG_DOCUMENTS_DIR = "${homeDir}/Documents";
        XDG_DOWNLOAD_DIR = "${homeDir}/Downloads";
        XDG_MUSIC_DIR = "${homeDir}/Music";
        XDG_PICTURES_DIR = "${homeDir}/Pictures";
        XDG_PUBLICSHARE_DIR = "${homeDir}/Public";
        XDG_TEMPLATES_DIR = "${homeDir}/Templates";
        XDG_VIDEOS_DIR = "${homeDir}/Videos";
      };
    in {
      hj = {
        packages = attrValues {
          inherit
            (pkgs)
            brightnessctl
            cliphist
            libnotify
            playerctl
            wl-clipboard
            ;
        };

        environment.sessionVariables =
          {
            TERMINAL = "kitty";
            EDITOR = "nvim";
            VISUAL = "nvim";
            NIXPKGS_ALLOW_UNFREE = "1";

            # xdg
            XDG_CACHE_HOME = config.hj.xdg.cache.directory;
            XDG_CONFIG_HOME = config.hj.xdg.config.directory;
            XDG_DATA_HOME = config.hj.xdg.data.directory;
            XDG_STATE_HOME = config.hj.xdg.state.directory;

            # stop libX11 from polluting $HOME with .compose-cache
            XCOMPOSECACHE = "${config.hj.xdg.cache.directory}/xcompose";
          }
          // xdg-user-dirs;

        # follow xdg user dirs spec, see hm for original implementation
        # https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg-user-dirs.nix
        xdg.config.files = {
          "user-dirs.conf".text = "enabled=False";
          "user-dirs.dirs" = {
            generator = toKeyValue {};
            # For some reason, these need to be wrapped with quotes to be valid.
            value = mapAttrs (_: value: ''"${value}"'') xdg-user-dirs;
          };
        };
      };
    };
  };
}
