# uwu-herdr

A single-layer [Wooting UwU](https://wooting.io/uwu) keymap for driving [herdr](https://herdr.dev), plus `hop.sh`, which jumps to whichever Claude Code agent is waiting on you.

Six keys, no layers, nothing to install beyond herdr itself.

| Key | Tap | Hold | Sends | Handled by |
|---|---|---|---|---|
| Top-left | Talk | – | Right Option | your push-to-talk app (e.g. Wispr Flow) |
| Top-middle | Hop | – | F13 | herdr → `hop.sh` |
| Top-right | Return | – | Enter | – |
| Bottom-left | ↓ | Next workspace | ↓ / F16 | herdr `next_workspace` |
| Bottom-middle | Esc | Next tab | Esc / F17 | herdr `next_tab` |
| Bottom-right | ↑ | Next agent | ↑ / F18 | herdr `next_agent` |

The top row is analog: Return sits deep so a brushed key can't approve a permission prompt, Talk and Hop sit shallow. The bottom row is Mod-Tap: tap for the key, hold for the F-key.

## Hop

`hop.sh` reads `herdr agent list`, picks the agent that needs you, and focuses it:

1. **Blocked** agents first (sitting at a permission prompt or a question), then **done** (finished and not yet looked at).
2. Newest state change first.
3. Skips the agent you're already on.
4. Nothing waiting → just raises iTerm.

It works across all workspaces and tabs. It runs inside iTerm only; macOS Shortcuts.app will record the UwU's F13 but never fires on it, so a global trigger needs a third-party hotkey tool.

## Setup

**1. Keyboard.** In [Wootility](https://wootility.io) import share code `233f472542c400165e6215a331e73b74d994`, or set it by hand:

- Top: Right Alt (1.2mm, Rapid Trigger off), F13 (1.8mm, Rapid Trigger on), Enter (3.6mm, Rapid Trigger off).
- Bottom, Advanced Keys → Mod-Tap, 350ms hold: tap ↓ / hold F16, tap Esc / hold F17, tap ↑ / hold F18. Bottom-right is Fn1 by default; remapping it gives up the Fn layers, which this layout doesn't use.

**2. Script.** Clone this repo to `~/dev/tooling/uwu-herder` (or anywhere, and adjust the path below). Requires `jq`, which recent macOS ships.

```sh
./test.sh   # self-check of the targeting logic
```

**3. herdr.** Add to `~/.config/herdr/config.toml`, then `herdr server reload-config`:

```toml
[keys]
next_workspace = "f16"
next_tab = ["prefix+n", "f17"]
next_agent = "f18"

[[keys.command]]
key = "f13"
type = "shell"
command = "$HOME/dev/tooling/uwu-herder/hop.sh"
```

**4. Terminal.** iTerm2 3.6.11 or newer passes F13+ to herdr via the kitty keyboard protocol. Other terminals with kitty protocol support should work; untested.

**5. Talk.** Set your dictation app's push-to-talk hotkey to Right Option.

## Why these choices

Planning trail, decisions and dead ends: [.scratch/uwu-keymap/map.md](.scratch/uwu-keymap/map.md). Borrows the Talk / Hop / Confirm idea from [3-key Claude](https://constdecimalserrno.dev/3kc/), without the app.
