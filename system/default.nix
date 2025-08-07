{
  lib,
  config,
  pkgs,
  user,
  flakePath,
  isLaptop,
  ...
}: {
  imports = [
    ./common
    ./optional
    ./hardware.nix
    ./style.nix
  ];

  services = {
    gvfs.enable = true; # automount disks
    logind.powerKey = lib.mkIf isLaptop "ignore"; # disable accidentary push powerkey
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };

  environment = {
    etc = {
      "gitconfig".text = config.hm.xdg.configFile."git/config".text; # universal git settings
      # get gparted to use system theme
      "xdg/gtk-3.0/settings.ini".text = config.hm.xdg.configFile."gtk-3.0/settings.ini".text;
      "xdg/gtk-4.0/settings.ini".text = config.hm.xdg.configFile."gtk-4.0/settings.ini".text;
    };

    # install fish completions for fish
    # https://github.com/nix-community/home-manager/pull/2408
    pathsToLink = ["/share/fish"];

    variables = {
      TERMINAL = config.hm.profiles.${user}.defaultTerminal.name;
      EDITOR = config.hm.profiles.${user}.defaultEditor.name;
      VISUAL = config.hm.profiles.${user}.defaultEditor.name;
      NIXPKGS_ALLOW_UNFREE = "1";
      STARSHIP_CONFIG = "${config.hm.xdg.configHome}/starship.toml";
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
          y # yazi
          ;
      };
    systemPackages = with pkgs;
      [
        bonk # mkdir and touch in one
        curl
        eza
        killall
        (lib.hiPrio procps) # for uptime
        ripgrep
        yazi
        zoxide
        # use same config as home-manager
        (pkgs.symlinkJoin {
          name = "yazi";
          paths = [pkgs.yazi];
          buildInputs = [pkgs.makeWrapper];
          postBuild =
            # sh
            ''wrapProgram $out/bin/yazi --set YAZI_CONFIG_HOME "${config.hm.xdg.configHome}/yazi"'';
          meta.mainProgram = "yazi";
        })
      ]
      ++
      # install gtk theme for root, some apps like gparted only run as root
      [
        config.hm.gtk.theme.package
        config.hm.gtk.iconTheme.package
      ]
      ++ [config.hm.profiles.${user}.defaultEditor.package]
      ++ (lib.optional config.hm.custom.neovim.enable neovim);
  };

  systemd.tmpfiles.rules =
    # cleanup systemd coredumps once a week
    lib.custom.nixos.mkRemove "/var/lib/systemd/coredump" {
      user = "root";
      group = "root";
      age = "7d";
    }
    # create symlink to dotfiles from default /etc/nixos
    ++ (lib.custom.nixos.mkSymlinks {
      dest = "/etc/nixos";
      src = flakePath;
    });

  programs = {
    # use same config as home-manager
    bash.interactiveShellInit = config.hm.programs.bash.initExtra;

    file-roller.enable = true;
    git.enable = true;

    # remove nano
    nano.enable = lib.mkForce false;
  };

  # setup fonts
  fonts = {
    enableDefaultPackages = true;
    packages = [config.hm.stylix.fonts.monospace.package]; # install monospace font for root
  };

  xdg = {
    # use mimetypes defined from home-manager
    mime = let
      hmMime = config.hm.xdg.mimeApps;
    in {
      enable = true;
      inherit (hmMime) defaultApplications;
      addedAssociations = hmMime.associations.added;
      removedAssociations = hmMime.associations.removed;
    };

    # fix opening terminal for nemo / thunar by using xdg-terminal-exec spec
    terminal-exec = {
      enable = true;
      settings = {
        default = ["${config.hm.profiles.${user}.defaultTerminal.name}.desktop"];
      };
    };
  };

  custom.persist = {
    root.directories = lib.optionals config.hm.custom.wifi.enable ["/etc/NetworkManager"];
    root.cache.directories = [
      "/var/lib/systemd/coredump"
    ];
  };
}
