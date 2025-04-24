[group('Basic')]
[doc('Edit justfile')]
@default:
  $EDITOR .justfile

[group('nh')]
[doc('Add file contents to the index')]
add:
  git add --all

[group('nh')]
[doc('Build and activate the new configuration, and make it the boot default')]
switch:
  nh os switch

[group('nh')]
[doc('Build and activate the new configuration')]
test:
  nh os test

[group('nh')]
[doc('Cleans root profiles and calls a store gc')]
clean:
  nh clean all --keep 5

[group('nh')]
[doc('Update flake inputs and activate the new configuration, make it the boot default')]
update:
  nh os switch -u
