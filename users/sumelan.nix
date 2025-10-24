{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.custom.tmpfiles) mkFiles mkSymlinks;
  username = "sumelan";
in {
  imports = [./.];

  users.users.${username} = {
    isNormalUser = true;
    # create a password with sumelan with:
    # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/sumelan
    initialPassword = "password";
    hashedPasswordFile = "/persist/etc/shadow/${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjto1d8D7GNrnS4mYx/l3qnxAlx04+0q7dceNUIdPxs sumelan"
    ];
  };

  # setup a file and user icon for accountservice
  # https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10?u=sumelan
  hm.home.file.".face".source = ./${username}.png;

  systemd.tmpfiles.rules =
    mkFiles "/var/lib/AccountsService/users/${username}" {
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
    ++ mkSymlinks {
      src = "${config.hm.home.homeDirectory}/.face";
      dest = "/var/lib/AccountsService/icons/${username}";
    };

  hm = {
    # define user profile
    profiles.${username} = {
      timeZone = "Asia/Tokyo";
      defaultLocale = "ja_JP.UTF-8";
      email = "sumelan@proton.me";
      defaultEditor = {
        package = pkgs.neovim;
        name = "nvim";
      };
    };
    # Japanese settings
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [pkgs.fcitx5-mozc];
        waylandFrontend = true;
        settings.addons.classicui.globalSection = {
          Font = "${config.hm.custom.fonts.regular} 13";
          MenuFont = "${config.hm.custom.fonts.regular} 13";
          TrayFont = "${config.hm.custom.fonts.regular} 13";
          UseDarkTheme = true;
          UseAccentColor = true;
        };
      };
    };
  };
}
