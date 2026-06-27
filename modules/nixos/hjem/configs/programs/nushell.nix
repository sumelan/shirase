{lib, ...}: {
  flake.custom.hjemConfigs.nushell = {user, ...}: {
    hjem.users.${user}.rum = {
      programs.nushell = {
        enable = lib.mkDefault true;
      };
    };
  };
}
