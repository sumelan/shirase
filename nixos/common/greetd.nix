{
  lib,
  pkgs,
  user,
  ...
}: let
  inherit (lib) concatStringsSep getExe;
in {
  # tty autologin
  services.getty.autologinUser = user;

  services.greetd = {
    enable = true;
    settings = {
      default_session = let
        theming = concatStringsSep ";" [
          "border=magenta"
          "text=cyan"
          "prompt=green"
          "time=red"
          "action=blue"
          "button=yellow"
          "container=black"
          "input=red"
        ];
        args = concatStringsSep " " [
          "--time" # display the current date and time
          "--theme '${theming}'"
          "--remember" # remember last logged-in username
          "--remember-user-session" # remember last selected session for each user
          "--user-menu" # allow graphical selection of users from a menu
          "--asterisks" # display asterisks when a secret is typed
          "--greeting 'Welcome back on Shirase'" # show custom text above login prompt
          "--cmd 'niri --session'"
        ];
      in {
        command = "${getExe pkgs.tuigreet} " + args;
        user = "greeter";
      };
    };
  };
}
