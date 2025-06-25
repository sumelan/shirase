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
