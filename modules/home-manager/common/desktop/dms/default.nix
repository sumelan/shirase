{lib, ...}: let
  inherit (lib) mkForce;
in {
  imports = [
    ./plugins.nix
    ./settings.nix
  ];

  programs = {
    # NOTE: edtting screenshot feature need niri-git
    dankMaterialShell = {
      enable = true;
      systemd.enable = true;
    };
  };

  # override service config flake provide
  systemd.user.services.dms.Service.Restart = mkForce "always";

  custom.persist = {
    home = {
      directories = [
        ".config/niri/dms"
        ".local/state/DankMaterialShell"
      ];
      cache.directories = [
        ".cache/DankMaterialShell"
      ];
    };
  };
}
