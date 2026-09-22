# List all clients appid
def mlsa [] {
  mmsg get all-clients | from json | get clients.appid
}

# List all clients title
def mlst [] {
  mmsg get all-clients | from json | get clients.title
}
