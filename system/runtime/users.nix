{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  users = {
    mutableUsers = false;

    # setup users with persistent passwords
    # https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
    # create a password with for root and $user with:
    # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/root
    users = {
      root = {
        initialPassword = "password";
        hashedPasswordFile = "/persist/etc/shadow/root";
      };
      ${user} = {
        isNormalUser = true;
        initialPassword = "password";
        hashedPasswordFile = "/persist/etc/shadow/${user}";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
  };

  services = lib.mkIf config.hm.custom.niri.enbale {
    displayManager.autoLogin = {
      enable = true;
      user = "${user}";
    };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.niri-stable}/bin/niri-session";
          user = "${user}";
        };
        default_session = initial_session;
      };
    };

    getty.autologinUser = config.services.displayManager.autoLogin.user;
  };
}
