#!/usr/bin/env bash
# Installs claude-usage tools into ~/.local/bin and ~/.claude/commands

set -e
REPO="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"
COMMANDS="$HOME/.claude/commands"

mkdir -p "$BIN" "$COMMANDS"

# Scripts
for script in claude-usage claude-usage-status claude-usage-mcp claude-dashboard; do
    cp "$REPO/bin/$script" "$BIN/$script"
    chmod +x "$BIN/$script"
    echo "  installed $BIN/$script"
done

# Claude slash commands
for cmd in "$REPO/commands/"*.md; do
    cp "$cmd" "$COMMANDS/"
    echo "  installed $COMMANDS/$(basename $cmd)"
done

# Aliases (add to ~/.bash_aliases if not already there)
ALIASES="$HOME/.bash_aliases"
touch "$ALIASES"
grep -q "alias cu=" "$ALIASES"  || echo "alias cu='claude-usage'"         >> "$ALIASES"
grep -q "alias cuw=" "$ALIASES" || echo "alias cuw='claude-usage --watch 30'" >> "$ALIASES"
echo "  aliases added to $ALIASES"

# Claude settings: register MCP server and status line
SETTINGS="$HOME/.claude/settings.json"
if [ -f "$SETTINGS" ]; then
    python3 - "$SETTINGS" "$BIN/claude-usage-mcp" <<'EOF'
import json, sys
path, mcp_bin = sys.argv[1], sys.argv[2]
with open(path) as f:
    cfg = json.load(f)
cfg.setdefault("statusLine", {"type": "command", "command": mcp_bin.replace("claude-usage-mcp","claude-usage-status")})
cfg.setdefault("mcpServers", {})["claude-usage"] = {
    "command": "python3",
    "args": [mcp_bin],
    "env": {"CLAUDE_LIMIT_5H": "45", "CLAUDE_LIMIT_5DAY": "225"}
}
with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
print("  updated ~/.claude/settings.json")
EOF
fi

echo ""
echo "Done! Run: source ~/.bash_aliases"
echo "Then restart Claude Code to activate the MCP server and status line."
