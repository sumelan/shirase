_: {
  flake.modules.nixos.obs-studio = _: {
    programs.obs-studio.enable = true;

    custom.fileSystem = {
      persist.home.directories = [
        ".config/obs-studio"
      ];
    };
  };
}
