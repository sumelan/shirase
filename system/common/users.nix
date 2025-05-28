{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  # silence warning about setting multiple user password options
  # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
  options = {
    warnings = lib.mkOption {
      apply = lib.filter (
        w: !(lib.strings.hasInfix "If multiple of these password options are set at the same time" w)
      );
    };
  };

  config = {
    # autologin
    services = {
      greetd =
        let
          inherit (config.hm.custom) autologinCommand;
        in
        lib.mkIf (autologinCommand != null) {
          enable = true;
          settings = {
            default_session = {
              command = # bash
                let
                  inherit (config.services.displayManager.sessionData) desktops;
                in
                ''
                  ${pkgs.greetd.tuigreet}/bin/tuigreet --time \
                    --sessions ${desktops}/share/xsessions:${desktops}/share/wayland-sessions \
                      --remember --remember-user-session --asterisks --cmd ${autologinCommand} \
                        --user-menu --greeting "Who are you?" --window-padding 2
                '';
              user = "greeter";
            };
          };
        };
    };

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
  };
}
