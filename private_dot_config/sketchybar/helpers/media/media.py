"""Read nowplaying-cli metadata, enriched by a local YouTube userscript."""

import base64
import fcntl
import hashlib
import json
import os
from pathlib import Path
import re
import socket
import subprocess
import sys
import tempfile
import time
import urllib.request

YOUTUBE_ENDPOINT = "http://127.0.0.1:8765/youtube"
YOUTUBE_PORT = 8765
VIDEO_ID = re.compile(r"[A-Za-z0-9_-]{11}\Z")
YOUTUBE_MAX_AGE = 10


def cache_dir():
    path = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "sketchybar"
    path.mkdir(parents=True, exist_ok=True)
    return path


def port_open():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(0.2)
        return sock.connect_ex(("127.0.0.1", YOUTUBE_PORT)) == 0


def ensure_server():
    if port_open():
        return
    with (cache_dir() / "media-server.lock").open("w") as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if port_open():
            return
        server = Path(__file__).with_name("media_server.py")
        process = subprocess.Popen(
            [sys.executable, str(server)],
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
        (cache_dir() / "media-server.pid").write_text(str(process.pid))


def youtube_state():
    try:
        with urllib.request.urlopen(YOUTUBE_ENDPOINT, timeout=1) as response:
            state = json.load(response)
    except (OSError, ValueError):
        return None
    if not isinstance(state, dict):
        return None

    video_id = state.get("videoId", "")
    if not isinstance(video_id, str) or not VIDEO_ID.match(video_id):
        return None
    if time.time() - state.get("updated", 0) > YOUTUBE_MAX_AGE:
        return None
    return state


def save_artwork(data, name, cache):
    """Cache a bar-sized PNG and return its path with a change-detection key."""
    digest = hashlib.sha256(data).hexdigest()
    cover = cache / (name + ".png")
    stamp = cache / (name + ".sha256")
    if cover.exists() and stamp.exists() and stamp.read_text() == digest:
        return cover, digest

    with tempfile.TemporaryDirectory(prefix="media-", dir=cache) as directory:
        source = Path(directory) / "source"
        resized = Path(directory) / "cover.png"
        source.write_bytes(data)
        subprocess.run(
            ["/usr/bin/sips", "-s", "format", "png", "-c", "28", "28",
             str(source), "--out", str(resized)],
            capture_output=True, check=True, timeout=5,
        )
        resized.replace(cover)
    stamp.write_text(digest)
    return cover, digest


def youtube_artwork(video_id, cache):
    cover = cache / ("youtube-" + video_id + ".png")
    if cover.exists():
        return cover, "youtube:" + video_id

    url = "https://i.ytimg.com/vi/" + video_id + "/mqdefault.jpg"
    try:
        with urllib.request.urlopen(url, timeout=3) as response:
            data = response.read()
        cover, _ = save_artwork(data, "youtube-" + video_id, cache)
        return cover, "youtube:" + video_id
    except (OSError, subprocess.SubprocessError):
        return None, None


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
        "org.mozilla.firefox": "Firefox",
    }.get(raw.get(prefix + "ClientBundleIdentifier"), "")
    info = {
        "app": app,
        "title": raw.get(prefix + "Title", ""),
        "artist": raw.get(prefix + "Artist") or raw.get(prefix + "Album", ""),
        "state": "playing" if (raw.get(prefix + "PlaybackRate") or 0) > 0 else "paused",
    }
    cache = cache_dir()

    if app == "Firefox":
        ensure_server()
        state = youtube_state()
        if state:
            info["title"] = state.get("title") or info["title"]
            info["artist"] = state.get("channel") or info["artist"]
            artwork, artwork_id = youtube_artwork(state["videoId"], cache)
            if artwork:
                info.update(artwork=str(artwork), artwork_id=artwork_id)
        return info

    artwork = raw.get(prefix + "ArtworkData") if app else None
    if artwork:
        cover, digest = save_artwork(base64.b64decode(artwork), "media-cover", cache)
        info.update(artwork=str(cover), artwork_id=digest)
    return info


try:
    print(json.dumps(now_playing()))
except (OSError, ValueError, subprocess.SubprocessError):
    print(json.dumps({"app": "", "state": "stopped"}))
