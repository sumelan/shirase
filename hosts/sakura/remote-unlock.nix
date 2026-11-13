_: {
  boot = {
    kernelModules = [
      "igc" # Ethernet controller: Intel Corporation Ethernet Controller I225-V (rev 03
      "mt7921e" # Network controller: MEDIATEK Corp. MT7921K (RZ608) Wi-Fi 6E 80MHz
    ];
    # Enable debug shell. Although it is not required,
    # enabling the debug shell allows you to enter the debug shell by press Ctrl+Alt+F9 during Stage 1.
    kernelParams = ["rd.systemd.debug_shell=1"];

    initrd = {
      kernelModules = [
        "igc" # Ethernet controller: Intel Corporation Ethernet Controller I225-V (rev 03
        "mt7921e" # Network controller: MEDIATEK Corp. MT7921K (RZ608) Wi-Fi 6E 80MHz
      ];

      network.ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          # A host key that lives in persistent storage, separate from
          # your regular SSH host key. You don't want to share host keys
          # between the initrd and the booted system.
          # hostKeys paths must be unquoted strings, otherwise you'll run into issues with boot.initrd.secrets
          /root/.ssh/initrd_ssh_ed25519_key
        ];
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINROlQPXpPry3pue6Wg0W3hhKVap5PoirEr5E7BiR2OJ root@omen"
        ];
      };

      systemd = {
        network = {
          enable = true;
          networks."10-eth" = {
            matchConfig.Name = "eno1";
            networkConfig.DHCP = "ipv4";
            # Wait until network interfaces have a routable address
            # https://wiki.archlinux.org/title/Systemd-networkd
            linkConfig.RequiredForOnline = "routable";
          };
        };
        users.root.shell = "/bin/systemd-tty-ask-password-agent";
      };
    };
  };
}
