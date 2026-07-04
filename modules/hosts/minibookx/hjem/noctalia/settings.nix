{lib, ...}: {
  flake.modules.nixos."hosts/minibookx" = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = lib.importTOML ./settings.toml;
      };
    };
  };
}
