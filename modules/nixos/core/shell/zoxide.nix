{pkgs, ...}: {
  environment.systemPackages = [pkgs.zoxide];

  # zoxide is initialized via `zoxide init fish <flags> | source` and is
  # therefore not wrapped with flags
  programs = {
    bash.interactiveShellInit = let
      flags = "--cmd cd";
    in
      pkgs.lib.mkAfter ''
        eval "$(${pkgs.lib.getExe pkgs.zoxide} init bash ${flags} )"
      '';
  };

  custom.fileSystem = {
    cache.home.directories = [
      ".local/share/zoxide"
    ];
  };
}
