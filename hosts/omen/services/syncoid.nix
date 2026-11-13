_: let
  publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEccK/BVlzlTuJJF+oU1pEWVehQSmTUVYbi1jNQrvLo8 syncoid@omen";
in {
  programs.ssh.knownHosts = {
    "syncoid".publicKey = publicKey;
  };
  services = {
    openssh.knownHosts = {
      "syncoid".publicKey = publicKey;
    };

    syncoid = {
      # 21:15 daily
      interval = "*-*-* 21:15:00";

      commands."remote-omen" = {
        source = "zroot/persist";
        target = "root@syncoid:IW2T/omen";
        sshKey = "/var/lib/syncoid/.ssh/id_ed25519";
        extraArgs = [
          # if a snapshot is destroyed on the source, its GUID survives as a bookmark
          "--create-bookmark"
          # syncoid use the newest existing snapshot on the source as the transfer endpoint
          "--no-sync-snap"
          # snapshots which are missing on the source will be destroyed on the target
          "--delete-target-snapshots"
        ];
        localSourceAllow = ["bookmark" "hold" "send" "snapshot" "destroy"];
        localTargetAllow = []; # target is remote server
      };
    };
  };
}
