# claude-usage

> Live usage monitor for [Claude Code](https://claude.ai/code) — terminal dashboard, status bar, and MCP plugin showing token usage, message counts, and 5h/5day limit progress with reset timers.

---

## Features

- **Status bar** — always-visible one-liner inside Claude Code showing limit % and reset times
- **Live dashboard** — full-screen terminal TUI that refreshes automatically
- **MCP plugin** — ask Claude "what's my usage?" and get instant stats inline
- **Slash commands** — `/usage` and `/dashboard` inside Claude Code
- **5h & 5-day limit bars** — real progress bars with countdown to reset
- **Cache hit rate** — see how efficiently your context is being reused
- **Zero dependencies\*** — reads Claude's local stats files, no API calls, no internet

> \* Dashboard requires `rich` (`pip install rich`), everything else is pure Python stdlib.

---

## Preview

```
5h: 51% [█████░░░░░] rst:2h45m | 5d: 44% [████░░░░░░] rst:2d18h | msgs:44
```

```
╭─ Claude Code Usage Dashboard ─────────────────────────────────────────╮
│                                                                         │
│  5-Hour Window                    │  Model: sonnet-4-6                 │
│  [████████░░░░░░░░░░░░░░] 48%     │    Input      : 42                 │
│  Resets in: 2h 45m                │    Output     : 5.9K               │
│                                   │    Cache read : 317.4K             │
│  5-Day Window                     │    Cache write: 52.6K              │
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

Then **restart Claude Code** to activate the MCP server and status bar.

---

## Usage

### Terminal commands

| Command | Description |
|---|---|
| `cu` | One-shot usage summary |
| `cuw` | Auto-refreshing summary (every 30s) |
| `claude-dashboard` | Full live TUI dashboard |
| `claude-dashboard 60` | Dashboard with custom interval |

### Inside Claude Code

| Type | What happens |
|---|---|
| `/usage` | Claude shows your usage stats inline |
| `/dashboard` | Claude opens the TUI in a new terminal |
| Ask *"what's my usage?"* | Claude calls the tool automatically |

---

## Configuration

Default limits (Claude Code Pro approximate). Override in `~/.claude/settings.json`:

```json
"env": {
  "CLAUDE_LIMIT_5H": "45",
  "CLAUDE_LIMIT_5DAY": "225"
}
```

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
```

---

## Files

```
claude-usage/
├── bin/
│   ├── claude-usage          # one-shot & watch mode
│   ├── claude-usage-status   # status bar script
│   ├── claude-usage-mcp      # MCP server (JSON-RPC over stdio)
│   └── claude-dashboard      # rich TUI dashboard
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
