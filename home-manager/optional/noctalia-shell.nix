{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [inputs.noctalia-shell.homeModules.noctalia-shell];

  options.custom = {
    noctalia-shell.enable = lib.mkEnableOption "Noctalia for Niri";
  };

  config = lib.mkIf config.custom.noctalia-shell.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
      spawn.enable = false;
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
