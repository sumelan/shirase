_: {
  flake.modules.nixos.core = {config, ...}: {
    # ssh settings
    services.openssh = {
      enable = true;
      settings = {
        # disable password auth.
        # NOTE: set false for better security
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # keyring settings
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    # run0-sudo-shim
    security = {
      # patching polkit to allow persistent authentication and adding rules
      polkit.persistentAuthentication = true;
      # run0-sudo-shim instead of sudo
      run0-sudo-shim.enable = true;
    };

    # gnuupg
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    environment.variables = {
      GNUPGHOME = "${config.hj.xdg.data.directory}/.gnupg";
    };

    # persist keyring and misc other secrets
    custom.fileSystem = {
      persist = {
        root.files = [
          # Required for SSH. If you have keys with different algorithms, then
          # you must also persist them here.
          "/etc/machine-id"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
        home.directories = [
          ".pki"
          ".ssh"
          ".local/share/.gnupg"
          ".local/share/keyrings"
        ];
      };
    };
  };
}
