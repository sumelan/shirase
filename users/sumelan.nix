{
  config,
  pkgs,
  ...
}: let
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMy/TE68lwvJBZ2oiWWQeP/6qTYKrphrYYbLdwYXfeIL sumelan"
    ];
  };

  # setup a file and user icon for accountservice
  # https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10?u=sumelan
  systemd.tmpfiles.settings = {
    "10-createAccountserviceFile" = {
      "/var/lib/AccountsService/users/${username}" = {
        "f+" = {
          group = "root";
          mode = "0600";
          user = "root";
          argument = ''
            [User]
            Session=niri
            SystemAccount=false
            Icon=/var/lib/AccountsService/icons/${username}
          '';
        };
      };
    };
    "10-symlinkIcon" = {
      "/var/lib/AccountsService/icons/${username}" = {
        "L+" = {
          argument = "${config.hm.home.homeDirectory}/.face";
        };
      };
    };
  };

  hm = {
    home.file.".face".source = ./${username}.png;

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
          Font = "${config.hm.custom.fonts.regular} 14";
          MenuFont = "${config.hm.custom.fonts.regular} 14";
          TrayFont = "${config.hm.custom.fonts.regular} 14";
          UseDarkTheme = true;
          UseAccentColor = true;
        };
      };
    };
  };
}
