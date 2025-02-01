# Edit justfile.
default:
  @$EDITOR .justfile

# Build and activate the new configuration, and make it the boot default.
[group('nh')]
switch:
  nh os switch

# Update flake inputs before building specified configuration.
[group('nh')]
update:
  nh os switch --update

# Cleans root profiles and calls a store gc.
[group('nh')]
clean:
  nh clean all

# Build and activate the new configuration.
[group('nh')]
test:
  nh os test

# Enter a Nix REPL with the target installable.
[group('nh')]
repl:
  nh os repl

# Updates the index using the current content found in the working tree.
[group('github')]
add:
  git add --all

# Incorporates changes from a remote repository into the current branch.
[group('github')]
pull:
  git pull origin main


