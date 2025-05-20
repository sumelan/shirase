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
add:
  git add --all

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
