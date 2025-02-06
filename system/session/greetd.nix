{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  services = lib.mkIf config.hm.custom.niri.enbale {
    displayManager.autoLogin = {
      enable = true;
      user = "${user}";
    };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.niri-stable}/bin/niri-session";
          user = "${user}";
        };
        default_session = initial_session;
      };
    };

    getty.autologinUser = config.services.displayManager.autoLogin.user;
  };
}
