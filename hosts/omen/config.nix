_: {
  imports = [
    ../../modules/nixos/game/steam.nix
    ../../modules/nixos/services/syncoid.nix
  ];

  networking.hostId = "8425e349";

  custom = {
    programs = {
      ssh.extraConfig = ''
        Host sakura-syncoid
          HostName 192.168.68.62
          Port 22
          User syncoid

          # Prevent using ssh-agent or another keyfile,
          # useful for testing
          IdentitiesOnly yes
          IdentityFile /var/lib/syncoid/.ssh/id_ed25519

        Host sakura-initrd
          HostName 192.168.68.62
          Port 2222
          User root

          # Prevent using ssh-agent or another keyfile,
          # useful for testing
          IdentitiesOnly yes
          IdentityFile /root/.ssh/id_ed25519
      '';
      btop.cudaSupport = true;
    };
  };
}
