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
        linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      };

      hj = {
        inherit user;
        directory = "/home/${user}";
      };
    };
  };
}
