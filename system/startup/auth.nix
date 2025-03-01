{
  lib,
  config,
  user,
  ...
}:
lib.mkMerge [
  # ssh settings
  {
    services.openssh = {
      enable = true;
      # disable password auth
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    users.users = {
      ${user}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA90FlIi09fQX3QfmscjCGLLwrL1z8xnnxXRhZ4pjHU3 sumelan@sumelan-acer"
      ];
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
      sudo = {
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
