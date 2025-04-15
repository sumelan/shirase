{
  lib,
  config,
  pkgs,
  host,
  inputs,
  ...
}:
{
  # Define your hostname
  networking.hostName = "${host}";

  networking = {
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
    };
  };

  environment.systemPackages = [
    pkgs.networkmanagerapplet
    inputs.agenix.packages."${pkgs.system}".default
  ];

  # Set your time zone
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties
  i18n.defaultLocale = "ja_JP.UTF-8";
  console = {
    # seems to break virtual-console service because it can't find the font
    # https://github.com/NixOS/nixpkgs/issues/257904
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Select internationalisation properties
  i18n = {
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

    # Japanese Input
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
      ];
      fcitx5.waylandFrontend = true;
    };
  };
  environment.sessionVariables = {
    NIX_PROFILES = "${lib.strings.concatStringsSep " " (
      lib.lists.reverseList config.environment.profiles
    )}";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
    # remove xterm
    excludePackages = [ pkgs.xterm ];
  };

  # enable sysrq in case for kernel panic
  # boot.kernel.sysctl."kernel.sysrq" = 1;

  # use dbus broker as default implementation
  services.dbus.implementation = "broker";

  # enable opengl
  hardware.graphics.enable = true;

  # zram
  zramSwap.enable = true;

  # do not change this value
  system.stateVersion = "24.05";
}
