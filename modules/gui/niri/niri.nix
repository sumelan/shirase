_: {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: {
    # niri-flake
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
    # use dms polkit
    systemd.user.services.niri-flake-polkit.enable = false;
    # portal
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = builtins.attrValues {
        inherit (pkgs) xdg-desktop-portal-gtk xdg-desktop-portal-gnome;
      };
      config = {
        common.default = ["gtk"];
        niri = {
          default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.Access" = ["gtk"];
          # use Nautilus
          "org.freedesktop.impl.portal.FileChooser" = ["gnome"];
          "org.freedesktop.impl.portal.Notification" = ["gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        };
        obs.default = ["gnome"];
      };
    };
    # dms
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = false;
    };
    # greeter
    # tty autologin
    services.getty.autologinUser = user;

    programs.dank-material-shell.greeter = {
      enable = true;
      compositor.name = "niri";
      # User home directory to copy configurations for greeter
      # If DMS config files are in non-standard locations then use the configFiles option instead
      configHome = "/home/${user}";
      configFiles = [
        "/home/${user}/.config/DankMaterialShell/default-settings.json"
      ];
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };
  };
}
