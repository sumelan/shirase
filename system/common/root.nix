{lib, ...}: {
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
    users = {
      mutableUsers = false;
      # setup users with persistent passwords
      # https://reddit.com/r/NixOS/comments/o1er2p/tmpfs_as_root_but_without_hardcoding_your/h22f1b9/
      # create a password with for root
      # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/root
      users = {
        root = {
          initialPassword = "password";
          hashedPasswordFile = "/persist/etc/shadow/root";
        };
      };
    };
  };
}
