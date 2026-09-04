_: {
  flake.custom.hjemConfigs.mangowm = {
    config,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      wayland.windowManager.mango = {
        enable = true;
        inherit (config.programs.mango) package;
        systemd = {
          enable = true;
          xdgAutostart = false;
        };
      };
    };
  };
}
