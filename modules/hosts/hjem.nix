{inputs, ...}: {
  flake.modules.nixos.hjem = {
    pkgs,
    user,
    ...
  }: {
    imports = [
      # alias for hjem
      (inputs.nixpkgs.lib.mkAliasOptionModule ["hj"] ["hjem" "users" user])
    ];

    config = {
      hjem = {
        clobberByDefault = true;
        linker = pkgs.smfh;
      };

      hj = {
        inherit user;
        directory = "/home/${user}";
      };
    };
  };
}
