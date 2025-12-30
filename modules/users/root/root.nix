_: {
  flake.modules.nixos.default = {
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
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0nylmhn7vyEeF1Lec3oAy2DbHOZrPYWZ5JkDefMslq root"
          ];
        };
      };
    };
  };
}
