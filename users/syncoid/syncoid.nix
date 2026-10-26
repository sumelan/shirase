{pkgs, ...}: {
  # allow syncoid to ssh into HDDs
  # NOTE: You need to allow user `syncoid` to some zfs commands
  # `sudo zfs allow -u syncoid clone,create,destroy,mount,mountpoint,receive,send,rollback,compression,snapshot,hold,release,keylocation,bookmark DATASET_or_POOL`
  users.users = {
    syncoid = {
      isNormalUser = false; # keep it a service account...
      group = "syncoid";
      shell = pkgs.bashInteractive; # ...but with a real shell
      # services.syncoid automaticall set user "syncoid" as systemuser
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGU8XyODM1wUPrd98dItryAHIXSHKUAM2RT42UtIKhBF syncoid@omen"
      ];
    };
  };
}
