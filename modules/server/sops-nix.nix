_: {
  flake.modules.nixos.sops-nix = {
    config,
    user,
    ...
  }: {
    sops = {
      # to edit secrets file, run `nix-shell -p sops --run "sops secrets/syncthing.yaml"`
      # after adding new host in `.sops.ymal`, run `nix-shell -p sops --run "sops updatekeys secrets/syncthing.yaml"`
      defaultSopsFile = ../../secrets/syncthing.yaml;

      age = {
        # This will automatically import SSH keys as age keys
        sshKeyPaths = ["/persist/home/${user}/.ssh/id_ed25519"];
        keyFile = "/persist/home/${user}/.config/sops/age/keys.txt";
        # This will generate a new key if the key specified above does not exist
        generateKey = false;
      };
      # This is the actual specification of the secrets.
      secrets = {
        # by default, secrets are owned by `root:root` and `/run/secrets.d` is only owned by root and the `keys` group has read access to it
        "syncthing/sakura-key" = {
          mode = "0440";
          owner = config.services.syncthing.user;
          inherit (config.services.syncthing) group;
        };
        "syncthing/minibookx-key" = {
          mode = "0440";
          owner = config.services.syncthing.user;
          inherit (config.services.syncthing) group;
        };
        "syncthing/sakura-cert" = {
          mode = "0440";
          owner = config.services.syncthing.user;
          inherit (config.services.syncthing) group;
        };
        "syncthing/minibookx-cert" = {
          mode = "0440";
          owner = config.services.syncthing.user;
          inherit (config.services.syncthing) group;
        };
        "syncthing/gui-password" = {
          mode = "0440";
          owner = config.services.syncthing.user;
          inherit (config.services.syncthing) group;
        };
      };
    };
    custom.persist.home.directories = [
      ".config/sops"
    ];
  };
}
