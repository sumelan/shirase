_: {
  flake.modules.nixos.podman = {pkgs, ...}: {
    environment.systemPackages = [pkgs.distrobox];

    virtualisation = {
      podman = {
        enable = true;
        # create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    # store docker images on /cache
    custom.cache.home.directories = [
      ".local/share/containers"
    ];
  };
}
