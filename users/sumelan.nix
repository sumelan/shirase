{
  lib,
  pkgs,
  config,
  user,
  isDesktop,
  ...
}:
{
  imports = [ ./. ];

  users.users.${user} = {
    isNormalUser = true;
    # create a password with $username with:
    # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/${username}
    initialPassword = "password";
    hashedPasswordFile = "/persist/etc/shadow/${user}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys =
      let
        pubKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0zoNZpdcUfZ/Nf8Nj248D3wGlQCLld3LjPGrA6zzXs sumelan"
        ];
      in
      lib.mkIf isDesktop pubKeys;
  };
  hm.profiles.${user} = {
    flakeDir = "${config.hm.home.homeDirectory}/projects/shirase";
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
