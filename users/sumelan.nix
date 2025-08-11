{
  lib,
  pkgs,
  isServer,
  ...
}: let
  username = "sumelan";
in {
  imports = [./.];

  users.users.${username} = {
    isNormalUser = true;
    # create a password with $username with:
    # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/${username}
    initialPassword = "password";
    hashedPasswordFile = "/persist/etc/shadow/${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = let
      pubKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0zoNZpdcUfZ/Nf8Nj248D3wGlQCLld3LjPGrA6zzXs sumelan"
      ];
    in
      lib.mkIf isServer pubKeys;
  };
  hm.profiles.${username} = {
    timeZone = "Asia/Tokyo";
    defaultLocale = "ja_JP.UTF-8";
    defaultEditor = {
      package = pkgs.neovim;
      name = "nvim";
    };
    defaultTerminal = {
      package = pkgs.kitty;
      name = "kitty";
    };
  };
}
