_: {
  flake.modules.nixos.wifi = {
    pkgs,
    user,
    ...
  }: {
    # wireshark
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark-cli; # `wireshark-cli` or `wireshark`
    };

    users.users.${user}.extraGroups = ["wireshark"];

    custom.fileSystem = {
      persist.root.directories = [
        "/etc/NetworkManager"
      ];
    };
  };
}
