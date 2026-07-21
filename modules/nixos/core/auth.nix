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
        # [info] disable password auth for better security
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    # keyring settings
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;

    security = {
      sudo.enable = false;

      run0 = {
        enable = true;
        sudo-shim.enable = true;
        persistentAuth = {
          enable = true;
          enableRemote = true;
        };
      };
    };

    # gnuupg
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # [warn] Some programs need SUID wrappers,
    # can be configured further or are started in user sessions.
    environment.variables = {
      GNUPGHOME = "${config.hjem.users.${user}.xdg.data.directory}/.gnupg";
    };
  };
}
