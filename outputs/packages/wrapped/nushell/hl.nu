# View journal with hl and hide all fields except MESSAGE
def jhl [] {
  journalctl -o json -a | hl -L --hide '*' --hide '!MESSAGE'
}

# Follow Live Logs (Streaming)
def jhlf [] {
  journalctl -o json -a -f | hl -P -L --hide '*' --hide '!MESSAGE'
}

# Show only error-level messages and above.
def jhle [] {
  journalctl -o json -a -p err | hl -L --hide '*' --hide '!MESSAGE'
}
