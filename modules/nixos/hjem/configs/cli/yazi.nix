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
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) yazi;
  in {
    hjem.users.${user}.packages =
      [yazi]
      ++ (lib.mapAttrsToList (
          name: file:
            pkgs.writeShellApplication {
              name = "yazi-print-${name}";
              runtimeInputs = [pkgs.bat];
              text = ''
                YAZI_PATH=$(grep "export YAZI_CONFIG_HOME=" '${lib.getExe yazi}' | cut -d"'" -f2)
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
