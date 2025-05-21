set shell := ["fish", "-c"]

[group('default')]
[doc('Listing available recipes')]
@default:
  @just --list

[group('Git')]
[doc('Add file contents to the index')]
add:
  git add --all

[group('Helper')]
[doc('Build and activate the new configuration, and make it the boot default')]
nh-switch:
  nh os switch
alias nhs := nh-switch

[group('Helper')]
[doc('Update flake inputs and activate the new configuration, make it the boot default')]
nh-update:
  nh os switch --update
alias nhu := nh-update

[group('Helper')]
[doc('Build and activate the new configuration')]
nh-test:
  nh os test
alias nht := nh-test

[group('Helper')]
[doc('Cleans root profiles and calls a store gc')]
nh-clean:
  nh clean all --keep 5
alias nhc := nh-clean

[group('Flag')]
[doc('Add update flag')]
uflag:
  touch $HOME/.cache/update-checker/nix-update-update-flag && pkill -x -RTMIN+12 .waybar-wrapped

[group('Flag')]
[doc('Add updtate and rebuild flag')]
rflag:
  touch $HOME/.cache/update-checker/nix-update-rebuild-flag && pkill -x -RTMIN+12 .waybar-wrapped

[group('Btrfs')]
[doc('List the differences between current / and blank state')]
diff:
  #!/usr/bin/env fish

  function try
      if ! $argv
          echo "ERROR ($argv)"
          exit 1
      end
  end

  sudo mkdir /mnt
  sudo mount -o subvol=/ /dev/nvme0n1p1 /mnt

  set OLD_TRANSID (sudo btrfs subvolume find-new /mnt/root-blank 9999999)
  set OLD_TRANSID (echo $OLD_TRANSID | string replace 'transid marker was ' '')

  try sudo btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
  sed '$d' |
  cut -f17- -d' ' |
  sort |
  uniq |
  while read path
      set path "/$path"
      if [ -L "$path" ]
          : # The path is a symbolic link, so is probably handled by NixOS already
      else if [ -d "$path" ]
          : # The path is a directory, ignore
      else
          echo "$path"
      end
  end

  sudo umount /mnt
  sudo rm -r /mnt
