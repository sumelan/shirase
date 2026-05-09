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
      ghostty
      eza
      eza-tree
      moor
      ns
      nvf
      ripgrep
      wlr-which-key
      ;
  in {
    imports = builtins.attrValues {
      # tui
      inherit (flake.modules.nixos) btop helix yazi yt-dlp zoxide;
      # mpd
      inherit (flake.modules.nixos) mpd rmpc;
      # browser
      inherit (flake.modules.nixos) helium;
      # image editor
      inherit (flake.modules.nixos) satty;
      # pdf viewer
      inherit (flake.modules.nixos) zathura;
      # file manager
      inherit (flake.modules.nixos) nautilus;
      # theming
      inherit (flake.modules.nixos) gtk qt cursor;
      # desktop
      inherit (flake.modules.nixos) dms niri;
    };

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
        # tui
        inherit bat batman eza eza-tree moor ripgrep;
        # editor
        inherit nvf;
        nvim-desktop-entry = lib.hiPrio nvim-desktop-entry;
        # nix-search-tv
        inherit ns;
        ns-desktop-entry = lib.hiPrio ns-desktop-entry;
        # terminal
        inherit ghostty;
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
        # desktop
        inherit wlr-which-key;
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

          TERMINAL = "ghostty";
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

      xdg = {
        config.files = {
          "user-dirs.conf".text = "enabled=False";

          "user-dirs.dirs" = {
            generator = lib.generators.toKeyValue {};
            # For some reason, these need to be wrapped with quotes to be valid.
            value = lib.mapAttrs (_: value: ''"${value}"'') xdg-user-dirs;
          };

          "ghostty/config" = {
            permissions = "666";
            text = "";
            type = "copy";
          };
        };

        mime-apps = {
          default-applications = {
            "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";

            "text/plain" = "nvim.desktop";
            "application/x-shellscript" = "nvim.desktop";
            "application/xml" = "nvim.desktop";
          };
          added-associations = {
            "text/csv" = "nvim.desktop";
          };
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".local/share/nvim" # data directory
        ".local/state/nvim" # persistent session info
        ".supermaven"
        ".local/share/supermaven"

        ".config/dissent"
        ".cache/euphonica"
        ".config/Slack"
        ".config/vesktop"
        ".local/state/mpv" # watch later
        ".config/YouTube Music"
        ".local/share/com.github.johnfactotum.Foliate"
      ];
      cache.home.directories = [
        ".cache/dissent"
        ".cache/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
