"""Read Slack's Dock badge, falling back to its persisted desktop state."""

import json
from pathlib import Path
import re
import subprocess


def command(*args):
    result = subprocess.run(args, capture_output=True, text=True, timeout=3)
    return result.returncode, result.stdout


def dock_badge(output):
    # lsappinfo normally prints StatusLabel={ "label"="1" }; NULL is unknown.
    match = re.search(r'"?label"?\s*=\s*"([^"]*)"', output)
    if not match:
        match = re.search(r'"?StatusLabel"?\s*=\s*"([^"]*)"', output)
    return match.group(1) if match else None


def state_badge(state):
    teams = state["webapp"]["teams"]
    if not isinstance(teams, dict):
        raise ValueError("Invalid workspace state")
    highlights = 0
    show_bullet = False
    for team in teams.values():
        unreads = team["unreads"]
        highlights += max(0, int(unreads.get("unreadHighlights", 0)))
        show_bullet |= bool(unreads.get("showBullet")) and unreads.get("unreads", 0) > 0
    # This matches Slack's own badge calculation, including across workspaces.
    return str(highlights) if highlights > 0 else "•" if show_bullet else ""


def read_badge():
    try:
        code, _ = command("/usr/bin/pgrep", "-x", "Slack")
        if code == 1:
            return {"running": False, "badge": "", "source": "stopped"}
        if code != 0:
            return {"running": True, "source": "unknown"}
        code, output = command("/usr/bin/lsappinfo", "info", "-only", "StatusLabel", "Slack")
        badge = dock_badge(output) if code == 0 else None
        if badge is not None:
            return {"running": True, "badge": badge, "source": "dock"}
        path = Path.home() / "Library/Application Support/Slack/storage/root-state.json"
        badge = state_badge(json.loads(path.read_text()))
        return {"running": True, "badge": badge, "source": "local-state"}
    except (OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError):
        # An unreadable or changing file must not be interpreted as all read.
        return {"running": True, "source": "unknown"}


if __name__ == "__main__":
    print(json.dumps(read_badge()))
