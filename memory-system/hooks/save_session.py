#!/usr/bin/env python3
"""
Sonmi452 Memory Hook — auto-triggered on session Stop.
Reads session transcript and appends relevant updates to memory files.

Triggered by: Claude Code Stop hook
"""

import json
import sys
import os
from datetime import date

MEMORY_DIR = os.path.expanduser("~/.claude/memory")
TODAY = date.today().isoformat()


def read_stdin():
    """Read hook payload from stdin."""
    try:
        return json.load(sys.stdin)
    except Exception:
        return {}


def append_to_file(filepath, content):
    """Append content to a memory file."""
    with open(filepath, "a", encoding="utf-8") as f:
        f.write(f"\n{content}\n")


def main():
    payload = read_stdin()

    # The hook receives session info — check for stop reason
    stop_reason = payload.get("stop_reason", "")
    transcript = payload.get("transcript", [])

    if not transcript:
        sys.exit(0)

    # Extract the last assistant message for context
    last_messages = [m for m in transcript if m.get("role") == "assistant"]
    if not last_messages:
        sys.exit(0)

    last_content = last_messages[-1].get("content", "")
    if isinstance(last_content, list):
        last_content = " ".join(
            block.get("text", "") for block in last_content
            if isinstance(block, dict) and block.get("type") == "text"
        )

    # Write a session marker to recurring-context.md so next session knows
    # a session ended here (Claude will fill in specifics during the session)
    marker_file = os.path.join(MEMORY_DIR, "recurring-context.md")
    if os.path.exists(marker_file):
        marker = f"- [{TODAY}] [auto] Session ended. Review context above for any in-progress tasks."
        # Only append if today's marker not already present
        with open(marker_file, "r", encoding="utf-8") as f:
            existing = f.read()
        if f"[{TODAY}] [auto]" not in existing:
            append_to_file(marker_file, marker)

    sys.exit(0)


if __name__ == "__main__":
    main()
