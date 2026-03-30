{
  config,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  flake.modules = {
    nixos.common = {
      pkgs,
      user,
      ...
    }: let
      flakePath = "/persist/home/${user}/Projects/shirase";
    in {
      # internationalisation properties
      # time zone
      time = {
        inherit (config.flake.meta.users.${user}) timeZone;
        hardwareClockInLocalTime = true;
      };
      # locale
      i18n = rec {
        inherit (config.flake.meta.users.${user}) defaultLocale;
        extraLocaleSettings = {
          LC_ADDRESS = defaultLocale;
          LC_IDENTIFICATION = defaultLocale;
          LC_MEASUREMENT = defaultLocale;
          LC_MONETARY = defaultLocale;
          LC_NAME = defaultLocale;
          LC_NUMERIC = defaultLocale;
          LC_PAPER = defaultLocale;
          LC_TELEPHONE = defaultLocale;
          LC_TIME = defaultLocale;
        };
      };
      # console
      # seems to break virtual-console service because it can't find the font
      # https://github.com/NixOS/nixpkgs/issues/257904
      # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
      console.useXkbConfig = true; # use xkb.options in tty.

      programs = {
        dconf.enable = true;
        seahorse.enable = true;
        nano.enable = mkForce false;
      };

      # services
      services = {
        # use dbus broker as default implementation
        dbus.implementation = "broker";
        # Enable fwupd (firmware updater)
        fwupd.enable = true;
        # Enable disk monitoring
        smartd = {
          enable = true;
          autodetect = true;
          notifications = {
            wall.enable = true;
          };
        };
        gvfs.enable = true; # automount disks

        xserver = {
          # Configure keymap in X11
          xkb = {
            layout = "us";
            variant = "";
          };
          # remove xterm
          excludePackages = [pkgs.xterm];
        };
      };

      # enable opengl
      hardware.graphics.enable = true;

      systemd.tmpfiles.rules = [
        # cleanup systemd coredumps once a week
        "D! /var/lib/systemd/coredump root root 7d"
        # create symlink to dotfiles from default /etc/nixos
        "L+ /etc/nixos - - - - ${flakePath}"
      ];

      # system.stateVersion
      # do not change this value
      system.stateVersion = "24.05";
    };

    homeManager.default = {user, ...}: {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
      home = {
        username = user;
        homeDirectory = "/home/" + user;
        # do not change this value
        stateVersion = "24.05";

        sessionVariables = {
          NIXPKGS_ALLOW_UNFREE = "1";
        };
      };
      xdg = {
        enable = true;
        userDirs.enable = true;
        mimeApps.enable = true;
      };
    };
  };
}
