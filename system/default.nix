{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./server
    ./agenix.nix
    ./audio.nix
    ./auth.nix
    ./backup.nix
    ./bluetooth.nix
    ./boot.nix
    ./btrfs.nix
    ./configuration.nix
    ./docker.nix
    ./gh.nix
    ./hyprland.nix
    ./keyd.nix
    ./nix.nix
    ./printing.nix
    ./qmk.nix
    ./specialisations.nix
    ./usb-audio.nix
    ./users.nix
  ];

  services = {
    # don’t shutdown when power button is short-pressed
    logind.extraConfig = ''
      HandlePowerKey=ignore
    '';

    # automount disks
    gvfs.enable = true;
    # devmon.enable = true;
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    # managing encryption keys and passwords in the GnomeKeyring
    seahorse.enable = true;
  };

  environment = {
    etc = {
      # universal git settings
      "gitconfig".text = config.hm.xdg.configFile."git/config".text;
      # get gparted to use system theme
      "xdg/gtk-3.0/settings.ini".text = config.hm.xdg.configFile."gtk-3.0/settings.ini".text;
      "xdg/gtk-4.0/settings.ini".text = config.hm.xdg.configFile."gtk-4.0/settings.ini".text;
    };

    # install fish completions for fish
    # https://github.com/nix-community/home-manager/pull/2408
    pathsToLink = [ "/share/fish" ];

    variables = {
      TERMINAL = lib.getExe config.hm.custom.terminal.package;
      EDITOR = "nvim";
      VISUAL = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
      STARSHIP_CONFIG = "${config.hm.xdg.configHome}/starship.toml";
    };

    # use some shell aliases from home manager
    shellAliases =
      {
        inherit (config.hm.programs.bash.shellAliases)
          eza
          ls
          ll
          la
          lla
          ;
      }
      // {
        inherit (config.hm.home.shellAliases)
          t # eza related
          y # yazi
          ;
      };

    systemPackages =
      with pkgs;
      [
        curl
        eza
        neovim
        procps
        ripgrep
        yazi
        zoxide
      ]
      ++
        # install gtk theme for root, some apps like gparted only run as root
        (with config.hm.gtk; [
          theme.package
          iconTheme.package
        ]);
  };

  # setup fonts
  fonts = {
    enableDefaultPackages = true;
    inherit (config.hm.custom.fonts) packages;
  };

  programs = {
    # use same config as home-manager
    bash.interactiveShellInit = config.hm.programs.bash.initExtra;

    file-roller.enable = true;

    # disable nano
    nano.enable = lib.mkForce false;
  };

  # use gtk theme on qt apps
  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  xdg = {
    # use mimetypes defined from home-manager
    mime =
      let
        hmMime = config.hm.xdg.mimeApps;
      in
      {
        enable = true;
        inherit (hmMime) defaultApplications;
        addedAssociations = hmMime.associations.added;
        removedAssociations = hmMime.associations.removed;
      };

    # fix opening terminal for nemo / thunar by using xdg-terminal-exec spec
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "${config.hm.custom.terminal.package.pname}.desktop" ];
      };
    };
  };
}
