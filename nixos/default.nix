{
  lib,
  config,
  pkgs,
  host,
  user,
  flakePath,
  ...
}: let
  inherit
    (lib)
    mkForce
    hiPrio
    optionals
    ;
  inherit
    (lib.custom.tmpfiles)
    mkSymlinks
    mkCreateAndRemove
    ;
in {
  imports = [
    ./common
    ./optional
    ./hardware.nix
    ./style.nix
  ];

  services.gvfs.enable = true; # automount disks

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
      TERMINAL = "kitty";
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

      # use same config as home-manager
      customYazi = pkgs.symlinkJoin {
        name = "yazi";
        paths = [pkgs.yazi];
        buildInputs = [pkgs.makeWrapper];
        postBuild =
          # sh
          ''wrapProgram $out/bin/yazi --set YAZI_CONFIG_HOME "${config.hm.xdg.configHome}/yazi"'';
        meta.mainProgram = "yazi";
      };

      # default editor
      defaultEditor = config.hm.profiles.${user}.defaultEditor.package;

      # use the package configured by nvf
      customNeovim = pkgs.custom.nvf.override {inherit host flakePath;};

      # install gtk theme for root, some apps like gparted only run as root
      gtkTheme = config.hm.gtk.theme.package;
      gtkIconTheme = config.hm.gtk.iconTheme.package;
    };
  };

  systemd.tmpfiles.rules =
    # cleanup systemd coredumps once a week
    mkCreateAndRemove "/var/lib/systemd/coredump" {
      user = "root";
      group = "root";
      age = "7d";
    }
    # create symlink to dotfiles from default /etc/nixos
    ++ (mkSymlinks {
      dest = "/etc/nixos";
      src = flakePath;
    });

  programs = {
    # use same config as home-manager
    bash.interactiveShellInit = config.hm.programs.bash.initExtra;

    file-roller.enable = true;
    git.enable = true;

    # remove nano
    nano.enable = mkForce false;
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
  };

  custom.persist = {
    root.directories = optionals config.hm.custom.wifi.enable ["/etc/NetworkManager"];
    root.cache.directories = [
      "/var/lib/systemd/coredump"
    ];
  };
}
