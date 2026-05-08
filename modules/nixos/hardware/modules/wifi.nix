_: {
  flake.modules.nixos.wifi = {
    pkgs,
    user,
    ...
  }: {
    # wireshark
    # programs.wireshark = {
    #   enable = true;
    #   package = pkgs.wireshark; # default value: wireshark-cli
    # };

    # users.users.${user}.extraGroups = ["wireshark"];

    custom.fileSystem = {
      persist.root.directories = [
        "/etc/NetworkManager"
      ];
    };
  };
}
