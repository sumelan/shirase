_: {
  flake.custom.hjemConfigs.mangowm = {
    config,
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
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

      packages = builtins.attrValues {
        inherit (pkgs) kooha;
      };
    };
  };
}
