{lib, ...}: {
  flake.modules.nixos."hosts/acer" = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        settings = lib.importTOML ./settings.toml;
      };
    };
  };
}
