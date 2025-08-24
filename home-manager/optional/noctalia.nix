{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia-shell.homeModules.noctalia-shell];

  options.custom = {
    noctalia.enable = lib.mkEnableOption "Noctalia for Niri";
  };

  config = lib.mkIf config.custom.noctalia.enable {
    programs.noctalia-shell = {
      enable = true;
      spawn.enable = true;
      systemd.enable = lib.mkForce false;
      keybinds = {
        enable = true;
      };
    };

    custom.persist = {
      home.directories = [
        ".config/noctalia"
      ];
    };
  };
}
