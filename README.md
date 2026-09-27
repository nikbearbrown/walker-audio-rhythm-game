# Walker Rhythm Game

This is Walker's standalone adaptation of Godot's `audio/rhythm_game` demo, and
unlike most Walker demo adaptations it is a small game: notes fall onto a guide
in time with a song, you press one button on the beat, and the game judges
each press as Perfect, Good or Miss and shows how many milliseconds early or
late you were. It exists in Walker to teach audio-clock-driven motion (see
GAME-BRIEF.md). Automated engine checks with real input events cover hit
windows, note motion, live scoring, pause and restart; nobody has yet
listened to it or play-tested it as a person, and hardware latency has not been
calibrated.

## How to run

Open godot/project.godot with regular Godot 4.7 or compatible newer Godot.

Controls: **Space** hits a note; **R** restarts; **P** or **Escape** pauses
(gamepad buttons 0, 3 and 6 are also bound). Existing settings expose
raw/filtered timing, input latency, scroll speed, and a metronome, plus
"Show offset on judgment" and a chart selector (The Comeback / Sync Test).

## Design

- [GDD.md](GDD.md) — recovered game design document (copy of `design/GDD.md`)
- [design/DECK.html](design/DECK.html) — review deck
- [design/IMPLEMENTATION-MAP.md](design/IMPLEMENTATION-MAP.md) — feature → scene/script/line
- [design/decisions.md](design/decisions.md) — open questions (Q-01..Q-14)

The GDD is a recovered, unapproved description of what the code does, written
by Walker's `/gdd reverse` pass in silent mode. No design gate is signed.
GAME-BRIEF.md is quoted as a stated, unsigned intent; player goals, pillars and
priorities are recorded as missing, not invented.

## Source & license

Standalone adaptation in progress of Godot's audio/rhythm_game demo. See
SOURCES.md for the copy date, upstream commit, the Godot demo MIT notice
(Godot Engine contributors, in LICENSE.md), the CC0 metronome recording and the
music track, whose track-specific provenance remains under review before film
distribution. Preserve the upstream checkout separately.

The first change was only the project name; GAME-BRIEF.md and FRICTIONAL.md
since record one more runtime change, safe handling of empty note input.

## Status

The first README listed behavioral verification as pending. GAME-BRIEF.md and
FRICTIONAL.md since record automated engine tests: import, constructed hit
windows and note motion, live-scene Space scoring, R restart and P
pause/resume. These are automated engine tests, not human listening, hardware
latency calibration or full-chart coverage.

Both Liam walkthrough/code-and-result films were listed as pending; the
walkthrough's own publication record is in
youtube/claude-liam-walker-audio-rhythm-game-walkthrough/PUBLISHED.md. No
public release yet. See SOURCES.md and FRICTIONAL.md.

Repository: https://github.com/nikbearbrown/walker-audio-rhythm-game
