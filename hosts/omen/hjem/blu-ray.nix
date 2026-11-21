{pkgs, ...}: let
  inherit (pkgs.lib) genAttrs;
in {
  # find usb bluray drive
  # https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714
  boot.kernelModules = ["sg"];

  nixpkgs.overlays = [
    (_final: prev: {
      # play Blu-ray disk
      vlc = prev.vlc.override {
        libbluray-full = prev.libbluray.override {
          withAACS = true;
          withBDplus = true;
        };
      };
    })
  ];

  hjem.users.sumelan = {
    packages = [
      pkgs.handbrake
      pkgs.makemkv
      pkgs.vlc
    ];

    xdg.mime-apps = let
      handbrake = "fr.handbrake.ghb.desktop";
      vlc = "vlc.desktop";
      associations = genAttrs [
        "audio/mp4"
        "audio/mpeg"
        "audio/ogg"
        "audio/flac"
        "video/mp4"
        "video/mpeg"
        "video/webm"
      ] (_: [handbrake vlc]);
    in {
      removed-associations = associations;
    };
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^vlc$"#'';}
        ];
        default-column-width._children = [
          {proportion = 0.450000;}
        ];
        default-window-height._children = [
          {proportion = 0.450000;}
        ];
        open-floating = true;
        opacity = 1.000000;
      }
    ];

    fileSystem = {
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
