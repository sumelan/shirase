{
  inputs,
  config,
  pkgs,
  ...
}: {
  services = {
    # set videodrivers to nvidia
    xserver.videoDrivers = ["nvidia"];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
      modesetting.enable = true; # required for Wayland
      # use official drivers
      open = false;
    };
  };

  hjem.users.sumelan.rum = {
    programs.sonora = let
      sonoraPkg = inputs.sonora.packages.${pkgs.stdenv.hostPlatform.system}.sonora-src;
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
