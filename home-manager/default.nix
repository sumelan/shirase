{
  lib,
  config,
  pkgs,
  user,
  ...
}:
{
  imports = [
    ./common
    ./optional
    ./style.nix
  ];

  options.custom = with lib; {
    autologinCommand = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Command to run after autologin";
    };
    symlinks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Symlinks to create in the format { dest = src;}";
    };
  };

  config = {
    home = {
      username = user;
      homeDirectory = "/home/${user}";
      # do not change this value
      stateVersion = "24.05";

      sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      };

      packages = with pkgs; [
        curl
        gzip
        trash-cli
        xdg-utils
      ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # create symlinks
    systemd.user.tmpfiles.rules =
      let
        normalizeHome = p: if (lib.hasPrefix "/home" p) then p else "${config.home.homeDirectory}/${p}";
      in
      lib.mapAttrsToList (dest: src: "L+ ${normalizeHome dest} - - - - ${src}") config.custom.symlinks;

    xdg = {
      enable = true;
      userDirs.enable = true;
      mimeApps.enable = true;
    };

    home.file = {
      ".face.icon" = {
        source = pkgs.fetchurl {
          url = "https://avatars.githubusercontent.com/${user}";
          sha256 = "sha256-LwDWTjMNZRegUfXnZUqCVCfbHJ0EuNn4toufwC5dgP8=";
        };
      };
      ".justfile".text = ''
        set shell := ["fish", "-c"]
        alias nhs := nh-switch
        alias nhu := nh-update
        alias nht := nh-test
        alias nhc := nh-clean

        [group('default')]
        [doc('Listing available recipes')]
        @default:
          @just --list

        [group('Git')]
        [doc('Add file contents to the index')]
        [no-cd]
        add:
          git add --all

        [group('Update')]
        [doc('Update your lock file')]
        checkup:
          @echo "Updating your lock file..."
          nh os switch --dry --update | tee | if grep -qe '\[U.]'; touch "$HOME/.cache/update-checker/nix-update-update-flag"; else; rm -f "$HOME/.cache/update-checker/nix-update-update-flag"; end

        [group('Update')]
        [doc('Update flake inputs and activate the new configuration, make it the boot default')]
        nixup:
          @echo "NixOS rebuilding..."
          nh os switch --update
          touch $HOME/.cache/update-checker/nix-update-rebuild-flag
          pkill -x -RTMIN+12 .waybar-wrapped

        [group('Helper')]
        [doc('Build and activate the new configuration, and make it the boot default')]
        nh-switch:
          nh os switch

        [group('Helper')]
        [doc('Update flake inputs and activate the new configuration, make it the boot default')]
        nh-update:
          nh os switch --update

        [group('Helper')]
        [doc('Build and activate the new configuration')]
        nh-test:
          nh os test

        [group('Helper')]
        [doc('Cleans root profiles and calls a store gc')]
        nh-clean:
          nh clean all --keep 5
      '';
    };

    custom.persist = {
      home.directories = [
        "Desktop"
        "Documents"
        "Downloads"
        "Music"
        "Pictures"
        "Videos"
      ];
    };
  };
}
