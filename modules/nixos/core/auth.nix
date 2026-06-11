_: {
  flake.modules.nixos.core = {
    config,
    user,
    ...
  }: {
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
      GNUPGHOME = "${config.hjem.users.${user}.xdg.data.directory}/.gnupg";
    };
  };
}
