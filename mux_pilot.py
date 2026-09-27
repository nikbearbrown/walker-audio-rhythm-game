"""Mux measured startup-pilot timestamps; no synthetic motion or audio stretching."""
import json
import subprocess
from pathlib import Path

root = Path(__file__).resolve().parent / "evidence/av-pilot-01"
rows = [json.loads(line) for line in (root / "timestamps.jsonl").read_text().splitlines()]
frames, end = rows[:-1], rows[-1]
assert all(row["save_error"] == 0 for row in frames)
assert end["audio_save_error"] == 0
assert all(b["time_s"] > a["time_s"] for a, b in zip(frames, frames[1:]))
lines = ["ffconcat version 1.0"]
for i, row in enumerate(frames):
    next_time = frames[i + 1]["time_s"] if i + 1 < len(frames) else end["end_s"]
    lines += [f"file '{row['frame']}'", "option framerate 1000000", f"duration {next_time-row['time_s']:.6f}"]
lines += [f"file '{frames[-1]['frame']}'", "option framerate 1000000"]
manifest = root / "measured.ffconcat"
manifest.write_text("\n".join(lines) + "\n")
subprocess.run([
    "ffmpeg", "-n", "-hide_banner", "-loglevel", "warning",
    "-itsoffset", str(frames[0]["time_s"]), "-safe", "0", "-f", "concat", "-i", str(manifest),
    "-i", str(root / "engine-mix.wav"), "-map", "0:v", "-map", "1:a",
    "-c:v", "libx264", "-preset", "fast", "-crf", "18", "-pix_fmt", "yuv420p",
    "-enc_time_base", "1:1000000", "-x264-params", "fps=30/1",
    "-fps_mode", "vfr", "-c:a", "aac", "-b:a", "192k", "-t", str(end["end_s"]),
    str(root / "measured-pilot-v2.mp4")
], check=True)
