# 5. SSH Authentication

## Two separate key systems — don't conflate them

**Host keys** identify the *server* to you. Dropbear's host keys (generated at install, `docs/03-installation.md`) are completely separate from your normal OS's SSH host keys — meaning the same machine, same IP, will show a *different* fingerprint depending on whether you're connecting during initramfs or after full boot. Expected, not a compromise — but verify against the fingerprint recorded at install time regardless.

**Authorized keys** identify *who's allowed to connect*. This is a separate file, `/etc/dropbear/initramfs/authorized_keys`, distinct from any user's normal `~/.ssh/authorized_keys`.

## Generate a dedicated client keypair

On your client machine, not the server:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/myserver_unlock
```

- `myserver_unlock` — **private**, never leaves this machine
- `myserver_unlock.pub` — **public**, this is what goes to the server

Use a dedicated key, not your everyday login key. If it's ever compromised, the blast radius is limited to exactly one narrow capability.

## Authorize and harden the key

```bash
cat ~/.ssh/myserver_unlock.pub
```

```bash
sudo nano /etc/dropbear/initramfs/authorized_keys
```

The finished line, restrictions included:

```
no-port-forwarding,no-agent-forwarding,no-x11-forwarding,command="/bin/cryptroot-unlock" ssh-ed25519 AAAA...your-key-here... myserver-unlock
```

### Exact syntax rules (this is the easiest place to make a mistake)

| Part | Example | Separator to next part |
|---|---|---|
| Restrictions (comma-joined, **zero spaces**) | `no-port-forwarding,no-agent-forwarding,no-x11-forwarding,command="/bin/cryptroot-unlock"` | **one space** |
| Key type | `ssh-ed25519` | **one space** |
| Key data | `AAAA...` | **one space** |
| Comment (optional) | `myserver-unlock` | end of line |

- The entire thing is **one unbroken line** — visual wrapping in your editor is fine, an actual line break is not
- **Zero spaces** anywhere inside the restrictions list
- Copy-paste the key data; never retype it by hand
- Use straight double quotes (`"`) around the command, never curly/smart quotes — some note apps and word processors auto-convert these, silently breaking the line

```bash
sudo chmod 600 /etc/dropbear/initramfs/authorized_keys
```

## What each restriction does

| Option | Effect |
|---|---|
| `command="/bin/cryptroot-unlock"` | Forces this exact command regardless of what the client requests — even a leaked key can only trigger the unlock prompt, never a shell |
| `no-port-forwarding` | Blocks tunneling other traffic through this session |
| `no-agent-forwarding` | Blocks forwarding your local SSH agent |
| `no-x11-forwarding` | Blocks forwarding graphical display traffic |

See `examples/authorized_keys.example` for a filled-in reference line.
