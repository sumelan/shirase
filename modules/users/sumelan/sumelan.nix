{config, ...}: {
  flake = {
    meta.users.sumelan = {
      name = "Default user of this flake";
      timeZone = "Asia/Tokyo";
      defaultLocale = "ja_JP.UTF-8";
      email = "sumelan@proton.me";
    };

    modules.generic.user_sumelan = {
      imports =
        [
          {
            users.users.sumelan = {
              description = config.flake.meta.users.sumelan.name;
              isNormalUser = true;
              # create a password with sumelan with:
              # mkpasswd -m sha-512 'PASSWORD' | sudo tee -a /persist/etc/shadow/sumelan
              initialPassword = "password";
              hashedPasswordFile = "/persist/etc/shadow/sumelan";
              extraGroups = [
                "networkmanager"
                "wheel"
              ];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0nylmhn7vyEeF1Lec3oAy2DbHOZrPYWZ5JkDefMslq sumelan"
              ];
            };

            # setup a file and user icon for accountservice
            # https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10?u=sumelan
            systemd.tmpfiles.settings = {
              "10-createAccountserviceFile" = {
                "/var/lib/AccountsService/users/sumelan" = {
                  "f+" = {
                    group = "root";
                    mode = "0600";
                    user = "root";
                    argument = ''
                      [User]
                      Session=niri
                      SystemAccount=false
                      Icon=/var/lib/AccountsService/icons/sumelan
                    '';
                  };
                };
              };
              "10-symlinkIcon" = {
                "/var/lib/AccountsService/icons/sumelan" = {
                  "L+" = {
                    argument = "/home/sumelan/.face";
                  };
                };
              };
            };
          }
        ]
        ++ [
          {
            hm.imports =
              [
                {
                  home.file.".face".source = ./sumelan.png;
                }
              ]
              ++ (with config.flake.modules.homeManager; [japanese]);
          }
        ];
    };
  };
}
