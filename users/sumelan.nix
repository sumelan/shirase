{
  lib,
  pkgs,
  config,
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

  # setup a file and user icon for accountservice
  # https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10?u=sumelan
  hm.home.file.".face".source = ./${username}.jpg;
  systemd.tmpfiles.rules =
    lib.custom.tmpfiles.mkFiles "/var/lib/AccountsService/users/${username}" {
      mode = "0600";
      user = "root";
      group = "root";
      content = pkgs.writeText "AccountService" ''
        [User]
        Session=niri
        SystemAccount=false
        Icon=/var/lib/AccountsService/icons/${username}
      '';
    }
    ++ lib.custom.tmpfiles.mkSymlinks {
      src = "${config.hm.home.homeDirectory}/.face";
      dest = "/var/lib/AccountsService/icons/${username}";
    };

  # define user profiles
  hm.profiles.${username} = {
    timeZone = "Asia/Tokyo";
    defaultLocale = "ja_JP.UTF-8";
    email = "sumelan@proton.me";
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
