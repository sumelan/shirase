{config, ...}: {
  flake.modules.nixos."users/sumelan" = {pkgs, ...}: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) japanese;
    };

    users.users.sumelan = {
      description = "Su melan";
      isNormalUser = true;
      shell = local.nushell;
      # create a password with sumelan with:
      # mkpasswd -m sha-512 'PASSWORD' | sudo tee /persist/etc/shadow/sumelan
      initialPassword = "password";
      hashedPasswordFile = "/persist/etc/shadow/sumelan";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHL2ZpvP+MowbQocG6NdBieeICjx4dnaDAbEEsA9P/W sumelan"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHN1uLZMMmZ0AzoFhww/9vaACBXwC+3WlI5Em0CwV9RN sumelan"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlj7/hkNiJkF1jhcgJGAu7Gv1kCV73d3pMNyylOFq8i sumelan"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGrnQWIYUVHiqsz5Eu/2DvBRZxGT23dMoKmnkxlKxZB0 sumelan"
      ];
    };

    services.accounts-daemon.enable = true;

    # setup a file and user icon for accountservice
    # https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233
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
            argument = "${./sumelan.png}";
          };
        };
      };
    };

    hjem.users.sumelan.files.".face".source = ./sumelan.png;
  };
}
