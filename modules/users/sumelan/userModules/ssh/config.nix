_: {
  flake.custom.userModules.sshConfig = {
    sakura = ''
      Host sakura
        HostName 192.168.68.62
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';

    minibookx = ''
      Host minibookx
        HostName 192.168.68.56
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';

    acer = ''
      Host acer
        HostName 192.168.68.55
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';

    omen = ''
      Host omen
        HostName 192.168.68.50
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };
}
