_: {
  flake.custom.hjemConfigs.blu-ray = {
    pkgs,
    user,
    ...
  }: {
    # find usb bluray drive
    # https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714
    boot.kernelModules = ["sg"];

    hjem.users.${user} = {
      packages = [
        pkgs.handbrake
        pkgs.makemkv
        pkgs.vlc
      ];

      xdg.mime-apps = let
        handbrake = "fr.handbrake.ghb.desktop";
        vlc = "vlc.desktop";
        associations = builtins.listToAttrs (map (name: {
            inherit name;
            value = [handbrake vlc];
          })
          [
            "audio/ogg"
            "audio/flac"
            "video/mp4"
          ]);
      in {
        removed-associations = associations;
      };
    };

    custom.fileSystem = {
      persist.home = {
        files = [
          ".config/aacs/KEYDB.cfg"
        ];
        directories = [
          ".config/ghb" # handbrake
          ".config/vlc"
          ".MakeMKV"
        ];
      };
    };
  };
}
