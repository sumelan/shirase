{
  lib,
  config,
  user,
  isServer,
  ...
}:
lib.mkMerge [

  # ssh settings
  {
    services.openssh = {
      enable = true;
      # disable password auth
      settings = {
        # NOTE: set false for better security
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    users.users =
      let
        pubKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0zoNZpdcUfZ/Nf8Nj248D3wGlQCLld3LjPGrA6zzXs sumelan"
        ];
      in
      {
        # path of remote host's authorized_keys
        ${user}.openssh.authorizedKeys.keys = lib.mkIf isServer pubKeys;
      };
  }

  # keyring settings
  {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
  }

  # security
  {
    security = {
      polkit.enable = true;
      # Use sudo-rs in place of regular sudo
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
        extraConfig = "Defaults passwd_tries=10";
      };
    } // lib.optionalAttrs config.hm.programs.hyprlock.enable { pam.services.hyprlock = { }; };
  }

  # gnuupg
  {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    environment.variables = {
      GNUPGHOME = "${config.hm.xdg.dataHome}/.gnupg";
    };
  }

  # persist
  {
    # persist keyring and misc other secrets
    custom.persist = {
      root = {
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };
      home = {
        directories = [
          ".pki"
          ".ssh"
          ".local/share/.gnupg"
          ".local/share/keyrings"
        ];
      };
    };
  }
]
