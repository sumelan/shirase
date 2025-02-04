{
  lib,
  config,
  ...
}:
lib.mkMerge [
  # ssh settings
  {
    services.openssh = {
      enable = true;
      # authorizedKeys.keys = [ ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
      };
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
      polkit.enable = true;
      sudo.wheelNeedsPassword = false;
      pam.services.hyprland.enableGnomeKeyring = true;
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
  }
]
