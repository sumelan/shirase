{config, ...}: {
  flake.modules.nixos.hjem = {user, ...}: {
    hjem = {
      clobberByDefault = true;
      extraModules =
        # Pull in all my modules
        builtins.attrValues config.flake.custom.hjemModules;

      users.${user} = {
        inherit user;
        directory = "/home/${user}";
      };
    };
  };
}
