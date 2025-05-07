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
        # set true if you test ssh-connection,
        # set false for better security
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = false;
      };
    };
    users.users =
      let
        keyFiles = [
          ../../hosts/sakura/sakura.pub
        ];
      in
      {
        # path of remote host's authorized_keys
        ${user}.openssh.authorizedKeys.keyFiles = lib.mkIf isServer keyFiles;
      };
  }

  # keyring settings
  {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
  }

  # misc
  {
    security = {
      # Use sudo-rs in place of regular sudo
      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
        extraConfig = "Defaults passwd_tries=10";
      };
      polkit.enable = true;
      pam.services.hyprlock = { };
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    environment.variables = {
      GNUPGHOME = "${config.hm.xdg.dataHome}/.gnupg";
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

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
