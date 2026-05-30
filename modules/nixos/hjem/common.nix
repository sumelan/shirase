{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos.hjem-common = {
    config,
    pkgs,
    ...
  }: let
    inherit
      (flake.packages.${pkgs.stdenv.hostPlatform.system})
      bat
      batman
      fish
      eza
      eza-tree
      moor
      ns
      nushell
      nvf
      ripgrep
      starship
      wlr-which-key
      zathura
      ;
  in {
    imports = builtins.attrValues flake.custom.hjemConfigs;

    # modules standalone
    hj = let
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

      nvim-direnv = pkgs.writeShellApplication {
        name = "nvim-direnv";
        runtimeInputs = [pkgs.direnv];
        text =
          # sh
          ''
            if ! direnv exec "$(dirname "$1")" nvim "$@"; then
                nvim "$@"
            fi
          '';
      };

      nvim-desktop-entry = pkgs.makeDesktopItem {
        name = "nvim";
        desktopName = "Neovim";
        genericName = "Text Editor";
        icon = "nvim";
        terminal = true;
        exec = "${lib.getExe nvim-direnv} %F";
      };

      ns-desktop-entry = pkgs.makeDesktopItem {
        name = "nix-search-tv";
        desktopName = "Nix Search TV";
        genericName = "Fuzzy search for Nix packages";
        icon = "dev.vlinkz.NixosConfEditor";
        terminal = true;
        exec = "ns";
      };
    in {
      packages = builtins.attrValues {
        # shell
        inherit fish nushell starship;
        # tui
        inherit bat batman eza eza-tree moor ripgrep ns;
        # editor
        inherit nvf;
        # desktop
        inherit wlr-which-key;
        nvim-desktop-entry = lib.hiPrio nvim-desktop-entry;
        ns-desktop-entry = lib.hiPrio ns-desktop-entry;
        # pdf viewer
        inherit zathura;
        # protonapps
        # NOTE: `protonmail-desktop` need to be started once through xwayland with
        # `XDG_SESSION_TYPE=x11 DISPLAY=:0 proton-mail`
        # but after that it worked without them
        # https://github.com/NixOS/nixpkgs/issues/365156#issuecomment-2585203352
        inherit (pkgs) protonmail-desktop proton-pass proton-vpn;
        # media
        inherit (pkgs) mpv pear-desktop euphonica;
        # ebook
        inherit (pkgs) foliate;
        # image viewer
        inherit (pkgs) swayimg;
        # discord
        inherit (pkgs) vesktop dissent;
        # slack
        inherit (pkgs) slack;
        # tools
        inherit (pkgs) brightnessctl cliphist libnotify playerctl wl-clipboard;
      };

      # misc
      environment.sessionVariables =
        {
          PAGER = "moor";
          SYSTEMD_PAGER = "moor";
          SYSTEMD_PAGERSECURE = "1";

          DEFAULT_BROWSER = "helium";
          BROWSER = "helium";

          TERMINAL = "foot";
          EDITOR = "hx";
          VISUAL = "hx";
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

      xdg = {
        config.files = {
          "user-dirs.conf".text = "enabled=False";

          "user-dirs.dirs" = {
            generator = lib.generators.toKeyValue {};
            # For some reason, these need to be wrapped with quotes to be valid.
            value = lib.mapAttrs (_: value: ''"${value}"'') xdg-user-dirs;
          };
        };

        mime-apps = let
          foot = "footclient.desktop";
          zathura = "org.pwmt.zathura-pdf-mupdf.desktop";
        in {
          default-applications = {
            "x-scheme-handler/terminal" = foot;

            "text/plain" = "helix.desktop";
            "application/x-shellscript" = "helix.desktop";
            "application/xml" = "helix.desktop";

            "x-scheme-handler/unknown" = "helium.desktop";
            "x-scheme-handler/about" = "helium.desktop";
            "x-scheme-handler/https" = "helium.desktop";
            "x-scheme-handler/http" = "helium.desktop";
            "text/html" = "helium.desktop";
          };
          added-associations = {
            "text/csv" = "helix.desktop";

            "x-scheme-handler/unknown" = "helium.desktop";
            "x-scheme-handler/about" = "helium.desktop";
            "x-scheme-handler/https" = "helium.desktop";
            "x-scheme-handler/http" = "helium.desktop";
            "text/html" = "helium.desktop";
          };

          removed-associations = {
            "audio/ogg" = "umpv.desktop";
            "audio/flac" = "umpv.desktop";
            "video/mp4" = "umpv.desktop";

            "image/jpeg" = zathura;
            "image/gif" = zathura;
            "image/webp" = zathura;
            "image/png" = zathura;
          };
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".supermaven"
        ".local/share/nvim" # data directory
        ".local/state/nvim" # persistent session info
        ".local/share/supermaven"
        ".local/state/mpv" # watch later
        ".local/share/com.github.johnfactotum.Foliate"

        ".config/dissent"
        ".config/Slack"
        ".config/vesktop"
        ".config/YouTube Music"
        ".config/Proton"
        ".config/Proton Mail"
        ".config/Proton Pass"
      ];
      cache.home.directories = [
        ".cache/dissent"
        ".cache/euphonica"
        ".cache/com.github.johnfactotum.Foliate"
        ".cache/Proton"
      ];
    };
  };
}
