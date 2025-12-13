{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit (lib) mkMerge;
in
  mkMerge [
    # internationalisation properties
    {
      # time zone
      time = {
        inherit (config.hm.profiles.${user}) timeZone;
        hardwareClockInLocalTime = true;
      };
      # locale
      i18n = rec {
        inherit (config.hm.profiles.${user}) defaultLocale;
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
    }
    # console
    # seems to break virtual-console service because it can't find the font
    # https://github.com/NixOS/nixpkgs/issues/257904
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    {
      console.useXkbConfig = true; # use xkb.options in tty.
    }
    # x11
    {
      services.xserver = {
        # Configure keymap in X11
        xkb = {
          layout = "us";
          variant = "";
        };
        # remove xterm
        excludePackages = [pkgs.xterm];
      };
    }
    # hardware
    {
      # enable opengl
      hardware.graphics.enable = true;
      # zram
      zramSwap.enable = true;
    }
    # services
    {
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
      };
    }
    # system.stateVersion
    {
      # do not change this value
      system.stateVersion = "24.05";
    }
  ]
