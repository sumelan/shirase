{lib, ...}: {
  flake.modules.nixos."hosts/sakura" = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = lib.importTOML ./settings.toml;
      };
    };
  };
}
