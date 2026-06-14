# claude-usage

> Live usage monitor for [Claude Code](https://claude.ai/code) — terminal dashboard, status bar, and MCP plugin showing token usage, message counts, and 5h/7day limit progress with reset timers.

---

## Features

- **Status bar** — always-visible one-liner inside Claude Code showing limit % and reset times
- **Live dashboard** — full-screen terminal TUI that refreshes automatically
- **Slash commands** — `/usage` and `/dashboard` inside Claude Code
- **5h & 7-day limit bars** — real progress bars with countdown to reset
- **Cache hit rate** — see how efficiently your context is being reused
- **Zero dependencies\*** — reads Claude's local stats files by default

> \* Dashboard requires `rich` (`pip install rich`), everything else is pure Python stdlib.

---

## Preview

```
5h: 51% [█████░░░░░] rst:2h45m | 7d: 44% [████░░░░░░] rst:2d18h | msgs:44
```

```
╭─ Claude Code Usage Dashboard ─────────────────────────────────────────╮
│                                                                         │
│  5-Hour Window                    │  Model: sonnet-4-6                 │
│  [████████░░░░░░░░░░░░░░] 48%     │    Input      : 42                 │
│  Resets in: 2h 45m                │    Output     : 5.9K               │
│                                   │    Cache read : 317.4K             │
│  7-Day Window                     │    Cache write: 52.6K              │
│  [█████████░░░░░░░░░░░░░] 44%     │    Cache hit  : ████████████ 85%   │
│  Resets in: 2d 18h                │                                    │
│                                   │  Totals                            │
│  Daily Activity                   │    Sessions : 3                    │
│  2026-06-14 ◀ today  msgs=22      │    Messages : 44                   │
│  2026-06-12          msgs=28      │    Longest  : 4 min, 14 messages   │
│  2026-06-11          msgs=16      │    Since    : 2026-06-11           │
│                                   │                                    │
╰─────────────────────────────────── Next refresh in 28s ───────────────╯
```

---

## Install

```bash
git clone https://github.com/VJ-Ranga/claude-usage.git
cd claude-usage
./install.sh
source ~/.bash_aliases
```

Then **restart Claude Code** to activate the status bar.

---

## Usage

### Terminal commands

| Command | Description |
|---|---|
| `cu` | One-shot usage summary |
| `cu --refresh` | Fetch live 5h/7d limit % from Anthropic API (manual) |
| `cuw` | Auto-refreshing summary (every 30s) |
| `claude-dashboard` | Full live TUI dashboard |
| `claude-dashboard 60` | Dashboard with custom interval |

### Inside Claude Code

| Type | What happens |
|---|---|
| `/usage` | Claude shows your usage stats inline |
| `/dashboard` | Claude opens the TUI in a new terminal |

---

## API refresh — manual only

By default, the status bar and CLI read from **local cache files only** — no API calls, no network, no tokens consumed.

The 5h/7d limit percentages are cached from the last time you manually refreshed. Run this whenever you want a live reading:

```bash
claude-usage --refresh
# or shorthand:
cu -r
```

> **Note:** `--refresh` uses Claude Code's internal session token to make one real API call to `api.anthropic.com` and reads the rate-limit headers from the response. Use it consciously — it counts as one message against your quota. No automatic background polling happens.

---

## How it works

```
You use Claude Code
       ↓
Claude writes stats to ~/.claude/stats-cache.json
                   and ~/.claude/history.jsonl
       ↓
claude-usage reads those files locally
       ↓
Displays usage — no API calls, no internet, no tokens used

(run  cu --refresh  any time you want live limit % from the API)
```

---

## Files

```
claude-usage/
├── bin/
│   ├── claude-usage          # one-shot & watch mode  (--refresh for live data)
│   ├── claude-usage-status   # status bar script (local cache only)
│   ├── claude-dashboard      # rich TUI dashboard
│   └── claude-fetch-limits   # called by --refresh to hit the API
├── commands/
│   ├── usage.md              # /usage slash command
│   └── dashboard.md          # /dashboard slash command
└── install.sh                # installs everything
```

---

## Requirements

- Python 3.8+
- [Claude Code](https://claude.ai/code)
- `rich` library for the dashboard: `pip install rich`

---

Made by [VJ-Ranga](https://github.com/VJ-Ranga)
