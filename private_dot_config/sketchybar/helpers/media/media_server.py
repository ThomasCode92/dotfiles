"""Local bridge for the SketchyBar YouTube userscript."""

import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
import re
import time

HOST = "127.0.0.1"
PORT = 8765
CACHE = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "sketchybar"
STATE = CACHE / "youtube.json"
VIDEO_ID = re.compile(r"[A-Za-z0-9_-]{11}\Z")


class Handler(BaseHTTPRequestHandler):
    def respond(self, status, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def do_POST(self):
        if self.path != "/youtube":
            self.respond(404, {"error": "not found"})
            return

        length = int(self.headers.get("Content-Length", 0))
        if not 0 < length <= 4096:
            self.respond(400, {"error": "invalid body"})
            return

        try:
            payload = json.loads(self.rfile.read(length))
            video_id = payload.get("videoId", "")
            if not isinstance(video_id, str) or not VIDEO_ID.match(video_id):
                raise ValueError("invalid video id")

            state = {
                "videoId": video_id,
                "title": str(payload.get("title", ""))[:200],
                "channel": str(payload.get("channel", ""))[:100],
                "playing": bool(payload.get("playing", False)),
                "updated": time.time(),
            }
            CACHE.mkdir(parents=True, exist_ok=True)
            STATE.write_text(json.dumps(state), encoding="utf-8")
            self.respond(200, {"ok": True})
        except (OSError, TypeError, ValueError):
            self.respond(400, {"error": "invalid payload"})

    def do_GET(self):
        if self.path != "/youtube":
            self.respond(404, {"error": "not found"})
            return

        try:
            state = json.loads(STATE.read_text(encoding="utf-8"))
            if not isinstance(state, dict):
                state = {}
        except (OSError, ValueError):
            state = {}
        self.respond(200, state)

    def log_message(self, format, *args):
        pass


def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    ThreadingHTTPServer((HOST, PORT), Handler).serve_forever()


if __name__ == "__main__":
    main()
