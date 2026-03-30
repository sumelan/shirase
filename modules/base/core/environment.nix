{lib, ...}: let
  inherit (builtins) attrValues;
  inherit (lib) mkForce hiPrio;
in {
  flake.modules.nixos.core = {
    config,
    pkgs,
    user,
    ...
  }: let
    inherit
      (config.hm.xdg)
      configHome
      mimeApps
      ;

    flakePath = "/persist/home/${user}/Projects/shirase";
  in {
    services.gvfs.enable = true; # automount disks
    programs = {
      dconf.enable = true;
      seahorse.enable = true;
    };
    environment = {
      variables = {
        TERMINAL = "kitty";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
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
      systemPackages = attrValues {
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
      # remove nano
      nano.enable = mkForce false;
    };
    # setup fonts
    fonts = {
      enableDefaultPackages = true;
      inherit (config.custom.fonts) packages;
    };

    xdg.mime = {
      enable = true;
      # use mimetypes defined from home-manager
      inherit (mimeApps) defaultApplications;
      addedAssociations = mimeApps.associations.added;
      removedAssociations = mimeApps.associations.removed;
    };

    custom.fileSystem = {
      cache.root.directories = [
        "/var/lib/systemd/coredump"
      ];
    };
  };
}
