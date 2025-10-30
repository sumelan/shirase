{lib, ...}: let
  inherit
    (lib)
    mkOption
    filter
    hasInfix
    ;
in {
  # silence warning about setting multiple user password options
  # https://github.com/NixOS/nixpkgs/pull/287506#issuecomment-1950958990
  options = {
    warnings = mkOption {
      apply = filter (
        w: !(hasInfix "If multiple of these password options are set at the same time" w)
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
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjto1d8D7GNrnS4mYx/l3qnxAlx04+0q7dceNUIdPxs root"
          ];
        };
      };
    };
  };
}
