{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./boot/boot.nix
    ./boot/specialisations.nix
    ./disk/btrfs.nix
    ./disk/impermanence.nix
    ./extra/opentabletdriver.nix
    ./extra/printing.nix
    ./extra/qmk.nix
    ./extra/usb-audio.nix
    ./runtime
    ./server
    ./session/greetd.nix
    ./session/niri.nix
    ./session/thunar.nix
    ./startup/auth.nix
    ./startup/nix.nix
    ./startup/users.nix
    ./agenix.nix
    ./backup.nix
    ./docker.nix
    ./gh.nix
  ];

  services = {
    # don’t shutdown when power button is short-pressed
    logind.extraConfig = "HandlePowerKey=ignore";

    # devmon.enable = true;
  };

  programs = {
    dconf.enable = true;
    # managing encryption keys and passwords in the GnomeKeyring
    seahorse.enable = true;
    nano.enable = lib.mkForce false;
  };

  systemPackages = with pkgs; [
        curl
        eza
        (lib.hiPrio procps) # for uptime
        neovim
        ripgrep
        yazi
        zoxide
  ];

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

    custom.persist = {
      root.directories = lib.optionals config.hm.custom.wifi.enable [
      "/etc/NetworkManager"
      ];
      root.cache.directories = [
        "/var/lib/systemd/coredump"
      ];

      home.directories = [ ".local/state/wireplumber" ];
    };
  };
}
