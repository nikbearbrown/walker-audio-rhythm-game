# Rhythm capture plan — not capture evidence

Source inspection: 2026-09-14. No footage is certified by this document.

## Clock constraint

The conductor combines AudioStreamPlayer playback position, audio mix timing,
output latency, and Time.get_ticks_usec(). A fixed simulation FPS alone does
not establish that Movie Maker's offline frames preserve this wall/audio-clock
relationship. Do not substitute a synthetic beat clock or accelerate the song
to obtain a convenient recording. First test a short real-time recording with
real audio and compare note crossings, input timestamps and recorded duration.
If offline recording is explored, it must independently pass that comparison
before being treated as rhythm-game evidence.

## Planned observable routes

1. Startup: show notes approaching the guide with the actual song audible.
2. Space: show a perfect hit, a good hit, an early miss and an unattended late
   miss. Use normal input and log the observed timing; do not assign scores.
3. Pause/resume with P: show the pause label and continuity after resuming.
4. Restart with R: show accumulated statistics resetting and the chart restarting.
5. Settings: interact with the actual filtered-playback, offset and metronome
   checkboxes, latency SpinBox and scroll slider. Show the consequence of each.
   A numeric change alone does not establish improved heard synchronization.
6. Chart selector: show the actual alternate chart and scene reload.
7. Completion: let the actual chart finish and show SongCompleteLabel and stats;
   no manual signal emission or removal of notes to manufacture completion.
8. Graph: show judgment dots and the moving time marker after actual inputs.

These are implemented features found in main.gd and note_manager.gd, not a
completed coverage ledger. Remaining runtime files still require full inventory.

## Development teaching pairs

- Chart subdivision loop → actual notes arriving at their chart spacing.
- Hit-window branches → actual differently timed input judgments.
- Stats signal/UI formatting → real counter and average-error updates.
- Filter selection → actual raw/filtered mode change; avoid claiming a measured
  improvement until a recording demonstrates it.
- Latency/scroll handlers → real control interaction and visible note motion.
- Graph drawing → real dots, colors and time marker after inputs.
- Restart/completion handlers → real restart and end-of-chart output.

Every excerpt immediately precedes its observed result. Extract exact source
lines only after the capture snapshot is fixed. No invented Inspector properties.

## Storage and audio

Observed 69 GiB available before capture preparation; retain 15 GB reserve.
Budget a short pilot first, probe actual native 3840x2160 pixels and audio,
then estimate longer takes from measured size. Keep the originals and input log.
Music is essential evidence here, not disposable background. Retain audible
game audio for demonstration intervals; duck only deliberately under narration.
Stop game audio before the stock outro. No public-upload permission is implied.

Headless input checks have passed, but neither heard synchronization, visual
coverage nor these recording routes has been verified yet.
