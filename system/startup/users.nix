{ user, ... }:
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
}
