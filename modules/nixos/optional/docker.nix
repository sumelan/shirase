{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.custom = {
    distrobox.enable = mkEnableOption "Enable distrobox";
    docker.enable =
      mkEnableOption "Enable docker"
      // {
        default = config.custom.distrobox.enable;
      };
  };

  config = mkIf config.custom.docker.enable {
    environment.systemPackages = mkIf config.custom.distrobox.enable [pkgs.distrobox];

    virtualisation = {
      podman = {
        enable = true;
        # create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
