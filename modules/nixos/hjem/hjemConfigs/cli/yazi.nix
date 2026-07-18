{
  config,
  lib,
  ...
}: {
  flake.custom.hjemConfigs.yazi = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user}.packages =
      [local.yazi]
      ++ (lib.mapAttrsToList (
          name: file:
            pkgs.writeShellApplication {
              name = "yazi-print-${name}";
              runtimeInputs = [local.moor];
              text = ''
                YAZI_PATH=$(grep "export YAZI_CONFIG_HOME=" '${lib.getExe local.yazi}' | cut -d"'" -f2)
                moor --lang toml "$YAZI_PATH/${file}"
              '';
            }
        )
        {
          config = "yazi.toml";
          theme = "theme.toml";
          keymap = "keymap.toml";
        });
  };
}
