{
  lib,
  pkgs,
  config,
  user,
  ...
}:
{
  users = {
    users.${user} = {
      isNormalUser = true;
      description = "${user}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.fish;
    };
  };

  services = {
    greetd =
      let
        inherit (config.hm.custom) autologinCommand;
      in
      lib.mkIf (autologinCommand != null) {
        enable = true;

        settings = {
          default_session = {
            command = autologinCommand;
          };

          initial_session = {
            inherit user;
            command = autologinCommand;
          };
        };
      };

    getty.autologinUser = config.services.displayManager.autoLogin.user;
  };
}
