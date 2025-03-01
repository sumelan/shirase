{
  lib,
  config,
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

  config = lib.mkMerge [
    {
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
                command = autologinCommand;
              };

              initial_session = {
                inherit user;
                command = autologinCommand;
              };
            };
          };

        getty.autologinUser = config.services.displayManager.autoLogin.user;
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
          btrbk = {
            description = "backup user using btrbk";
            initialPassword = "password";
            hashedPasswordFile = "/persit/etc/shadow/btrbk";
            extraGroups = [
              "btrbk"
            ];
          };
        };
      };
    }

    # TODO use agenix/sops for user passwords if enabled

  ];
}
