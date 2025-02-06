{
  pkgs,
  user,
  host,
  ...
}:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./keyd.nix
    ./niri.nix
    ./stylix.nix
  ];

  networking.hostName = "${user}-${host}"; # Define your hostname.

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
  };

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

  # use dbus broker as the default implementation
  services.dbus.implementation = "broker";

  # enable opengl
  hardware.graphics = {
    enable = true;
  };

  # zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
    swapDevices = 1;
  };

  # do not change this value
  system.stateVersion = "24.05";
}
