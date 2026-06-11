{lib, ...}: {
  flake.custom.hjemConfigs.zoxide = {
    pkgs,
    user,
    ...
  }: let
    flags = "--cmd cd";
  in {
    environment.shellAliases = {
      z = "zoxide query -i";
    };

    hjem.users.${user}.packages = [pkgs.zoxide];

    # zoxide is initialized via `zoxide init fish <flags> | source` and is
    # therefore not wrapped with flags
    programs = {
      bash.interactiveShellInit = lib.mkAfter ''
        eval "$(${lib.getExe pkgs.zoxide} init bash ${flags} )"
      '';
    };

    custom.fileSystem = {
      cache.home.directories = [".local/share/zoxide"];
    };
  };
}
