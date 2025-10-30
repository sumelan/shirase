# If the exclamation mark ("!") is used, this line is only safe to
# execute during boot, and can break a running system.
# The file access mode to use when creating this file or directory.
# If omitted or when set to "-",
# the default is used: 0755 for directories, 0644 for all other file objects.
_: {
  # Create a symlink if it does not exist yet.
  # If suffixed with + and a file or directory already exists where the symlink is to be created,
  # it will be removed and be replaced by the symlink.
  mkSymlinks = {
    dest,
    src,
  }: ["L+ ${dest} - - - - ${src}"];

  #  f will create a file if it does not exist yet.
  # If the argument parameter is given and the file did not exist yet,
  # it will be written to the file.  f+ will create or truncate the file.
  # If the argument parameter is given, it will be written to the file. Does not follow symlinks.

  mkFiles = target: {
    mode ? "-",
    user,
    group,
    content ? "-",
  }: ["f+ ${target} ${mode} ${user} ${group} - ${content}"];

  # Create a directory.
  # The mode and ownership will be adjusted if specified.
  # Contents of this directory are subject to time-based cleanup and remove if the age argument is specified.

  mkCreateAndRemove = target: {
    mode ? "-",
    user,
    group,
    age,
  }: ["D! ${target} ${mode} ${user} ${group} ${age}"];

  # Create a Directory.
  # Just cealn up  if age argument is specified.
  mkCreateAndCleanup = target: {
    mode ? "-",
    user,
    group,
    age ? "-",
  }: ["d! ${target} ${mode} ${user} ${group} ${age}"];
}
