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
        IdentityFile ~/.ssh/sakura
    '';

    minibookx = ''
      Host minibookx
        HostName 192.168.68.55
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/minibookx
    '';

    acer = ''
      Host acer
        HostName 192.168.68.55
        Port 22
        User sumelan

        # Prevent using ssh-agent or another keyfile,
        # useful for testing
        IdentitiesOnly yes
        IdentityFile ~/.ssh/acer
    '';
  };
}
