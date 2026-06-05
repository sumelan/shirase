#!/usr/bin/env nu

let tmp = (mktemp)

let updateLock = (nix flake update --output-lock-file $tmp)

if not ($updateLock | path exists) {
  rm $tmp
  exit 1
}

let old_record = (nix flake archive --json | from json)



