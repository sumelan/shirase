{
  config,
  pkgs,
  ...
}: {
  hjem.users.sumelan = {
    rum = {
      wayland.windowManager.mango = {
        enable = true;
        inherit (config.programs.mango) package;
        systemd = {
          enable = true;
          xdgAutostart = false;
        };
      };
    };

    packages = [pkgs.kooha];
  };
}
