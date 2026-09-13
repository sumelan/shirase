{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    user,
    ...
  }: let
    cfg = config.services.displayManager.noctalia-greeter;
    local = flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.noctalia = {
      enable = true;
      package = local.noctalia;
      systemd.enable = true;
    };

    services.displayManager.noctalia-greeter = {
      enable = true;

      settings = {
        cursor = {
          size = 28;
          theme = cfg.cursorTheme.name;
        };
        user = {
          default = user;
        };
        output = {
          transforms = "DSI-1:270";
        };
        appearance = {
          scheme = "Synced";
          hide_logo = true;
          font_family = config.custom.fonts.regular;
        };
        keyboard = {
          layout = "us";
        };
      };

      cursorTheme = {
        inherit (config.custom.gtk.cursor) name package;
      };
    };
  };
}
