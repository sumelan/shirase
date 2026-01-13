{lib, ...}: let
  inherit (lib) mkForce hiPrio;
in {
  flake.modules.nixos.default = {
    config,
    pkgs,
    user,
    ...
  }: let
    inherit
      (config.hm.xdg)
      configFile
      configHome
      mimeApps
      ;

    flakePath = "/persist/home/${user}/Projects/shirase";
    # use same yazi config as home-manager
    hmYazi = pkgs.symlinkJoin {
      name = "yazi";
      paths = [pkgs.yazi];
      buildInputs = [pkgs.makeWrapper];
      postBuild =
        # sh
        ''
          wrapProgram $out/bin/yazi --set YAZI_CONFIG_HOME "${configHome}/yazi"
        '';
      meta.mainProgram = "yazi";
    };
  in {
    services.gvfs.enable = true; # automount disks
    programs = {
      dconf.enable = true;
      seahorse.enable = true;
    };
    environment = {
      etc = {
        "gitconfig".text = configFile."git/config".text; # universal git settings
        # get gparted to use system theme
        "xdg/gtk-3.0/settings.ini".text = configFile."gtk-3.0/settings.ini".text;
        "xdg/gtk-4.0/settings.ini".text = configFile."gtk-4.0/settings.ini".text;
      };
      # install fish completions for fish
      # https://github.com/nix-community/home-manager/pull/2408
      pathsToLink = ["/share/fish"];
      variables = {
        TERMINAL = "kitty";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
        STARSHIP_CONFIG = "${configHome}/starship.toml";
      };
      # use some shell aliases from home manager
      shellAliases =
        {
          inherit
            (config.hm.programs.bash.shellAliases)
            eza
            ls
            ll
            la
            lla
            ;
        }
        // {
          inherit
            (config.hm.home.shellAliases)
            gg # lazygit
            y # yazi
            ;
        };
      systemPackages = builtins.attrValues {
        inherit
          (pkgs)
          bonk # mkdir and touch in one
          curl
          eza
          killall
          ripgrep
          yazi
          zoxide
          ;

        forUptime = hiPrio pkgs.procps; # for uptime

        inherit hmYazi;

        # install gtk theme for root, some apps like gparted only run as root
        gtkTheme = config.hm.gtk.theme.package;
        gtkIconTheme = config.hm.gtk.iconTheme.package;
      };
    };
    systemd.tmpfiles.settings = {
      # cleanup systemd coredumps once a week
      "10-cleanupCoredumps" = {
        "/var/lib/systemd/coredump" = {
          "D!" = {
            group = "root";
            user = "root";
            age = "7d";
          };
        };
      };
      # create symlink to dotfiles from default /etc/nixos
      "10-symlinkDotfiles" = {
        "/etc/nixos" = {
          "L+" = {
            argument = flakePath;
          };
        };
      };
    };
    programs = {
      git.enable = true;
      # use same config as home-manager
      bash.interactiveShellInit = config.hm.programs.bash.initExtra;
      # remove nano
      nano.enable = mkForce false;
    };
    # setup fonts
    fonts = {
      enableDefaultPackages = true;
      inherit (config.hm.custom.fonts) packages;
    };
    # use gtk theme on qt apps
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };
    xdg.mime = {
      enable = true;
      # use mimetypes defined from home-manager
      inherit (mimeApps) defaultApplications;
      addedAssociations = mimeApps.associations.added;
      removedAssociations = mimeApps.associations.removed;
    };
    custom.cache.root.directories = [
      "/var/lib/systemd/coredump"
    ];
  };
}
