{inputs, ...}: {
  flake.modules.nixos."hosts/omen" = {
    pkgs,
    user,
    ...
  }: let
    sonoraPkg = inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.sonora;
    wrappedSonora = pkgs.symlinkJoin {
      name = "sonora";
      paths = [sonoraPkg];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        rm $out/bin/.sonora-wrapped

        wrapProgram $out/bin/sonora \
            --set VK_DRIVER_FILES ${pkgs.mesa}/share/vulkan/icd.d/lvp_icd.x86_64.json
      '';
    };
  in {
    hjem.users.${user}.rum = {
      programs.sonora = {
        package = wrappedSonora;
      };
    };
  };
}
