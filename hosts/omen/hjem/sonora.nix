{
  inputs,
  pkgs,
  ...
}: {
  hjem.users.sumelan.rum = {
    programs.sonora = let
      sonoraPkg = inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.default;
      wrappedSonora = pkgs.symlinkJoin {
        name = "sonora";
        paths = [sonoraPkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          rm -f $out/bin/.sonora-wrapped

          wrapProgram $out/bin/sonora \
              --set VK_DRIVER_FILES ${pkgs.mesa}/share/vulkan/icd.d/lvp_icd.x86_64.json
        '';
      };
    in {
      package = wrappedSonora;
    };
  };
}
