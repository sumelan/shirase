{lib, ...}: let
  inherit (lib) mkForce;
in {
  flake.modules.nixos.common = {
    pkgs,
    dotfile,
    ...
  }: {
    # internationalisation properties
    # time zone
    time = {
      timeZone = "Asia/Tokyo";
      hardwareClockInLocalTime = true;
    };
    # locale
    i18n = {
      defaultLocale = "ja_JP.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "ja_JP.UTF-8";
        LC_IDENTIFICATION = "ja_JP.UTF-8";
        LC_MEASUREMENT = "ja_JP.UTF-8";
        LC_MONETARY = "ja_JP.UTF-8";
        LC_NAME = "ja_JP.UTF-8";
        LC_NUMERIC = "ja_JP.UTF-8";
        LC_PAPER = "ja_JP.UTF-8";
        LC_TELEPHONE = "ja_JP.UTF-8";
        LC_TIME = "ja_JP.UTF-8";
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
      "L+ /etc/nixos - - - - ${dotfile}"
    ];

    # system.stateVersion
    # do not change this value
    system.stateVersion = "24.05";
  };
}
