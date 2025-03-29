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
[doc('Update flake inputs and activate the new configuration, make it the boot default')]
update:
  nh os switch -u

[group('eww')]
[doc('Relaod statusbar and sidebar configured using eww')]
eww:
  eww kill --config ~/.config/eww/statusbar && \
    eww kill --config ~/.config/eww/sidebar && \
      eww open --config ~/.config/eww/statusbar statusbar --arg stacking=overlay && \
        eww open --config ~/.config/eww/sidebar sidebar
