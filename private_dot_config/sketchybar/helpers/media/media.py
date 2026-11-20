"""Read nowplaying-cli metadata and cache bar-sized artwork."""

import base64
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile


def now_playing():
    result = subprocess.run(
        ["nowplaying-cli", "get-raw"], capture_output=True, text=True,
        check=True, timeout=5,
    )
    raw = json.loads(result.stdout)
    prefix = "kMRMediaRemoteNowPlayingInfo"
    app = {
        "com.spotify.client": "Spotify",
        "com.apple.Music": "Music",
    }.get(raw.get(prefix + "ClientBundleIdentifier"), "")
    info = {
        "app": app,
        "title": raw.get(prefix + "Title", ""),
        "artist": raw.get(prefix + "Artist") or raw.get(prefix + "Album", ""),
        "state": "playing" if (raw.get(prefix + "PlaybackRate") or 0) > 0 else "paused",
    }
    artwork = raw.get(prefix + "ArtworkData") if app else None
    if artwork:
        data = base64.b64decode(artwork)
        digest = hashlib.sha256(data).hexdigest()
        cache = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "sketchybar"
        cache.mkdir(parents=True, exist_ok=True)
        cover = cache / "media-cover.png"
        stamp = cache / "media-cover.sha256"
        if not cover.exists() or not stamp.exists() or stamp.read_text() != digest:
            with tempfile.TemporaryDirectory(prefix="media-", dir=cache) as directory:
                source = Path(directory) / "source"
                resized = Path(directory) / "cover.png"
                source.write_bytes(data)
                subprocess.run(
                    ["/usr/bin/sips", "-s", "format", "png", "-z", "28", "28",
                     str(source), "--out", str(resized)],
                    capture_output=True, check=True, timeout=5,
                )
                resized.replace(cover)
            stamp.write_text(digest)
        info.update(artwork=str(cover), artwork_id=digest)
    return info


try:
    print(json.dumps(now_playing()))
except (OSError, ValueError, subprocess.SubprocessError):
    print(json.dumps({"app": "", "state": "stopped"}))
