_: {
  flake.modules.nixos.gui = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = pkgs.niri;

      useNautilus = true;
      withUWSM = false;
      withXDG = true;
    };
  };
}
