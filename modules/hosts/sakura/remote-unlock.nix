_: {
  flake.modules.nixos."hosts/sakura" = _: {
    # In order to use DHCP in the initrd,
    # network manager must not be enabled and `networking.useDHCP = true;` must be set.
    networking = {
      networkmanager.enable = false;
      useDHCP = true;
    };

    boot.initrd = {
      availableKernelModules = [
        "igc" # Ethernet controller: Intel Corporation Ethernet Controller I225-V (rev 03
        "mt7921e" # Network controller: MEDIATEK Corp. MT7921K (RZ608) Wi-Fi 6E 80MHz
      ];

      network = {
        enable = true;
        # Start an SSH server in the initrd on port 2222.
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [
            # A host key that lives in persistent storage, separate from
            # your regular SSH host key. You don't want to share host keys
            # between the initrd and the booted system.
            "/root/.ssh/id_ed25519"
          ];
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBwzwh8wrgqbmq0KhxoQvxEdc9Aii36QZrdR3Op5XELF root@omen"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJn7N/yLqZHDo9pNRjszgwA94lYk8ZYnHpTXx660MFSR root@minibookx"
          ];
        };
      };

      # Write a .profile to /var/empty (root's home in the systemd initrd)
      # so that logging in over SSH automatically starts the password agent.
      # https://elis.nu/blog/2026/04/nixos-zfs-remote-unlock-over-ssh
      systemd.services.zfs-setup-root-profile = {
        description = "Prepare root .profile for ZFS unlocking via SSH";
        wantedBy = ["initrd.target"];
        before = ["initrd-root-fs.target"];
        unitConfig.DefaultDependencies = false;
        script = ''
          mkdir -p /var/empty
          echo "systemd-tty-ask-password-agent --watch" > /var/empty/.profile
        '';
        serviceConfig.Type = "oneshot";
      };
    };
  };
}
