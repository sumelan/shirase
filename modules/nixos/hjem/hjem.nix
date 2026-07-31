{config, ...}: {
  flake.modules.nixos.hjem = {
    pkgs,
    user,
    ...
  }: {
    hjem = {
      clobberByDefault = true;
      linker = pkgs.smfh;
      # Pull in all my modules
      extraModules = builtins.attrValues config.flake.custom.hjemModules;

      users.${user} = {
        inherit user;
        directory = "/home/${user}";
      };
    };
  };
}
