# Frictional

2026-09-29 UTC continuation: Both walkthrough and gamedev landscape MP4s exist at
3840x2160, with SHA-256 hashes matching their `ready` export receipts. The
walkthrough structural check passes 17 implemented features, 20 evidence
intervals and three native captures. The development check passes 15 exact
code excerpts immediately followed by hashed visible results. Inspected the
actual gamedev master contact sheet, the walkthrough capture contact sheet and
their written event-sequence/visual reports; automated Gate V/T reports have
no blockers. These are machine and visual checks, not a listening or human
playtest. Heard song-to-note synchronization and complete audio-transition
review remain open. The series queue is corrected from stale `import-passed` to
`film-production`; neither film is declared human-approved or review-ready.

2026-09-14 UTC: Created a separate copy without changing upstream or the framework.
Renamed the project only. Source audit flagged a possible empty-note indexing
edge case and a possible metronome units mismatch; neither is runtime confirmed.
See ../walker-demo-series/RHYTHM-SOURCE-AUDIT.md. Import is the next check;
it does not prove audio synchronization, gameplay correctness, or film readiness.

Headless editor import with installed Godot 4.7.2 completed with exit 0
(execution session 55621). Runtime, normal-input checks and listening remain pending.

00:53 UTC: Ran the real main scene headlessly with --quit-after 180 (session
86859). Exit code 0, but shutdown reported four leaked ObjectDB instances and
two resources still in use. This is not a clean runtime pass. No interaction
or perceived audio-sync claim follows from this short run. Next inspect verbose
shutdown and normal-input behavior in a dedicated test harness. The source
scene sets process_mode=3 for always-running nodes; music file format tags
returned empty, so track-specific attribution is still unresolved.

01:24 UTC verbose repeat (session11499) reproduced the same shutdown warnings.
All four leaked objects are Ogg playback objects: OggPacketSequence,
AudioStreamOggVorbis, AudioStreamPlaybackOggVorbis, OggPacketSequencePlayback.
The two retained resources point to music/the_comeback2.ogg. This narrows the
shutdown investigation to audio playback cleanup; it does not establish a cause
or warrant removing the music. Preserve the warning and test graceful stop next.

02:10 UTC: test_shutdown.gd loads the actual main scene, waits one second,
stops the conductor, frees the scene and waits two frames before quitting.
Godot headless verbose run session6054 exited0 without the preceding leak/resource
warnings. This supports orderly teardown as a workaround for the abrupt-exit
probe, not a blanket gameplay correctness claim. Runtime source is unchanged;
the diagnostic is separate and must not be presented as gameplay capture.

02:41 UTC: Added test_pause_input.gd. It sends P key press/release events
through Input.parse_input_event to the actual scene, without calling its pause
handler directly. Session59723 printed INPUT_PAUSE true INPUT_RESUME true and
exited0: tree pause and visible PauseLabel toggled correctly in both directions.
The four Ogg-object/two-resource shutdown warnings returned despite stop/free,
so graceful cleanup is not yet a reliable fix across pause/resume. Preserve that
distinction; input assertions passed, overall clean shutdown did not.

03:13 UTC: test_note_motion.gd exercised the actual Note scene at constructed
120 BPM/400 scroll-speed samples: one beat before, at, and one beat after the
target yielded y=-200,0,100. All three assertions passed, exit0 without warnings.
This checks the pre/post-judgment motion formula, not live audio synchronization.
Vorbis stream tags (unlike format tags) identify the song as The Second Comeback,
Juan Linietsky, 2019. Attribution found; no separate track license claim added.

03:45 UTC: Added a constructed hit-window fixture, test_hit_windows.gd.
It failed to compile in standalone --script mode: its inherited NoteManager
dependency could not resolve GlobalSettings during early script compilation.
Stopped only this diagnostic session29915 with Ctrl-C after its script errored.
No hit-window assertions passed. Keep the fixture as failure evidence; next move
the fixture to a scene-based test loaded after autoload initialization. Runtime
game sources remain unchanged; do not confuse this harness failure with gameplay.

04:16 UTC: Preserved the failed standalone harness and added a scene-based
variant (test_hit_windows.tscn + test_hit_windows_scene.gd). With autoloads
initialized, all six constructed timing cases passed: zero and ±50 ms perfect,
±100 ms good, and -200 ms early miss. Exit0, no warnings. This uses a timing
fixture and calls the real classification method, not simulated human gameplay;
normal-input hit tests and live synchronization remain required.

04:48 UTC: Added an empty-list guard to the copied game's _handle_keypress:
the final note may have expired in _miss_old_notes earlier in the same frame.
Added an empty-input constructed case; all seven component assertions pass
without errors, exit0. This is defensive source hardening, not a claimed
reproduction of that frame-timing edge case through real input. Upstream remains
untouched. Existing six timing classifications retain their results.

05:19 UTC: test_live_hit.gd sent a Space key event through normal engine input
when the first real chart note reached the judgment window. It did not retime
the clock or modify the chart. Session79468 printed LIVE_SPACE_PERFECT true and
the actual UI label Perfect: 1; exit0. This is an automated live-scene input
test, still headless, not heard audio synchronization or captured gameplay.
Ogg shutdown resource warnings remain; no claim of an overall clean pass.

05:51 UTC: test_live_restart.gd first scored a perfect hit via Space, then sent
R through Input.parse_input_event. The real scene reloaded and its perfect count
reset to zero: LIVE_SPACE_PERFECT true and LIVE_RESTART_RESET true, session69451,
exit0. Ogg cleanup warnings persist. This adds normal-input restart evidence,
not audiovisual capture or human playtesting.

06:22 UTC: Added a 0.2-second wait after conductor.stop() in the pause-input
diagnostic only, allowing asynchronous audio playback cleanup before scene free.
Session66749: INPUT_PAUSE true INPUT_RESUME true, exit0 with no shutdown warnings.
This single successful run supports an audio-thread teardown timing explanation;
repeat before treating it as reliable. No runtime audio behavior was changed.

06:54 UTC: Repeated the delayed-cleanup pause/resume diagnostic three times
(session55720). All three printed both true assertions and exited0, with no
shutdown warnings. Together with the prior run this is four clean diagnostic
runs, not proof across every backend or capture configuration. Next apply the
same orderly shutdown to recording harnesses, keeping original gameplay clocks.

07:57 UTC: Resumed session97948 from the previous continuation. The delayed
cleanup restart diagnostic completed with LIVE_SPACE_PERFECT true and
LIVE_RESTART_RESET true, exit0, without shutdown warnings. The 200ms drain is
only in the test harness; game timing and music are unchanged. This extends
cleanup evidence to scene restart but is not a listening or capture check.

The standalone live-hit diagnostic with the same drain also completed cleanly
(session66676): LIVE_SPACE_PERFECT true, label Perfect: 1, exit0, no warnings.
Both previously warning-producing harnesses now have a clean observed run.

08:29 UTC: Prepared CAPTURE-PLAN.md from the conductor, note manager and main
scene source. Identified a recording risk: the conductor mixes wall-clock and
audio-clock timing, so fixed-FPS offline output cannot simply be assumed to
preserve rhythm synchronization. Planned a short audiovisual pilot before full
takes; no capture or synchronization pass is claimed. 69 GiB available.

09:02 UTC: Added a read-only clock-progress diagnostic. Installed Godot help
confirms --write-movie forces fixed FPS and --fixed-fps disables real-time
synchronization. Headless session46348 exited0 without warnings, but after
5.003698 wall seconds the raw audio clock advanced4.600598 seconds and filtered
clock4.594425 seconds. Headless selects Dummy audio, so this is not evidence of
heard CoreAudio synchronization or a defect in the audible game. It establishes
that this headless route must not be used as time-faithful footage without more
verification. Next compare CoreAudio in a real rendered pilot; preserve clocks.

09:33 UTC: Ran the same read-only diagnostic with the real macOS OpenGL renderer
and explicit CoreAudio (session3773), not --headless or fixed FPS. Exit0, no
warnings. Over5.005942 wall seconds, raw advanced5.005179485s and filtered
advanced5.008494013s (elapsed deltas about-0.76ms and+2.55ms respectively).
This removes the large Dummy-driver drift in this short observed run. It does
not measure absolute audio/visual latency or certify heard synchronization.
Use this real-time backend for the capture pilot; no clock substitution needed.

10:04 UTC: Actual viewport pilot (session5995) requested3840x2160 but received
3840x2008, saved evidence/viewport-pilot-01/actual-engine.png, and correctly
exited1 on the size assertion. Inspected the PNG: settings, chart selector,
counters, guide and graph are visible; no gameplay action is established by
this startup still. Window sizing appears display-clamped. Do not upscale this
as native4K evidence. Next test an isolated SubViewport at3840x2160, preserving
the1280x720 logical layout and normal input/audio clocks. Original game unchanged.

10:36 UTC: Isolated SubViewport diagnostic session26131 rendered an actual
3840x2160 texture with1280x720 logical layout, saved
evidence/subviewport-pilot-01/actual-engine.png, and exited0 without warnings.
Inspected the still: controls, graph and guide fit the16:9 canvas. This avoids
the window clamp without enlarging a recorded image. Normal-input routing,
restart ownership and synchronized motion/audio capture in this viewport still
need testing; the still is not a completed walkthrough or proof of play.

11:08 UTC: Native-size SubViewport with CoreAudio accepted a normal Space
InputEventKey and scored one perfect hit (session50697,
SUBVIEWPORT_SPACE_PERFECT true, exit0, no warnings). The driver observed the
real note delta and sent input; it did not assign scores or alter the clock.
This proves the global action path works in this configuration, not mouse UI,
restart scene ownership, recorded motion, or heard synchronization.

11:39 UTC: SubViewport mouse diagnostic session48626 sent actual left-button
press/release events through viewport.push_input at the offset checkbox's
logical center(202,438.5). SUBVIEWPORT_MOUSE_OFFSET_TOGGLE true, exit0, no
warnings. No direct button-state assignment or handler invocation was used.
This verifies a normal GUI input path at the native render size, not yet all
settings or a motion/audio recording. Scripted inputs must remain disclosed.

12:43 UTC: Restart diagnostic session63261 failed as a capture-architecture
test, exit1: SceneTree rejected a nested SubViewport child as current_scene
(must be a direct root child); real R input then reported current_scene null.
No runtime game files changed. The earlier root-scene restart test still stands.
Do not claim the nested capture setup supports restart. Next use a root-owned
wrapper scene containing the capture viewport, so normal reload recreates that
wrapper, or a root-render-target strategy; verify before recording completion.

13:14 UTC: Added a diagnostic PackedScene wrapper with the unmodified real
main scene inside its native3840x2160 SubViewport. Wrapper is root-owned and
current_scene. Normal R input reloaded it successfully (session59665:
WRAPPER_RELOAD true NATIVE_SIZE true, exit0, no warnings). This fixes capture
ownership without changing the game's restart handler. Wrapper recreation is
capture infrastructure, not a new game feature. No recorded motion/audio yet.

13:46 UTC: CoreAudio master-bus recording pilot session63871 saved an actual
engine mix to evidence/audio-pilot-01/engine-mix.wav, exit0 without warnings.
ffmpeg decoded stereo48kHz16-bitPCM,3.872s, mean-44.4dB and peak-26.8dB.
This startup excerpt is non-silent but quiet; no loudness gain was applied.
The4-second timer did not yield exactly4seconds of samples, so record exact
audio onset/length and frame timestamps before muxing. No sync/listening pass
is claimed. The recorder effect was removed before orderly shutdown.

14:18 UTC: Repeated audio pilot with measured wall duration and a200ms drain
before reading the recording (session57290). New file engine-mix-drained.wav
preserves the first take. Measured request interval3.877356s, recording
3.882666667s, difference+5.31ms; exit0 without warnings. The nominal4s scene
timer was not a4s wall-clock interval, so the previous length discrepancy must
not be attributed solely to lost audio samples. Use monotonic timestamps,
not requested timer values, for the combined pilot. Absolute sync still pending.

14:50 UTC: Combined real-time SubViewport/CoreAudio pilot session51007 saved
89 native-size JPEG frames plus engine-mix.wav and monotonic timestamps under
evidence/av-pilot-01. Wall interval6.005006s, audio6.005333333s; exit0 without
warnings. Frames are sampled around15fps, not30fps; no retiming or interpolation
has been applied. This startup capture has no scripted player input and is not
feature coverage. Next inspect frames, mux with actual timestamps, and measure
audio onset before planning input-driven takes. No final film produced.

15:22 UTC: Inspected the final pilot frame: UI/guide/graph visible, no note
action, so this remains startup-only evidence. Added mux_pilot.py to use actual
frame intervals and audio without stretching. Created av-pilot-01/measured-pilot.mp4;
ffmpeg exited0 but warned about nominal encoder macroblock rate from the fine
concat time base and deprecated JPEG pixel range. Compatibility/color and PTS
verification remain pending; this is not a final export or certified sync pass.

15:53 UTC: Compared every decoded video presentation timestamp with the pilot's
monotonic capture log. All89 source frames are present; maximum absolute PTS
error0.000825s, firstPTS0.005s, lastPTS5.948042s. This establishes sub-millisecond
timestamp preservation for this startup pilot, not audio onset alignment, heard
sync, playback compatibility or action coverage. Encoder warning remains open.

16:25 UTC: First encoder-metadata revision failed: this ffmpeg rejects output
-r30 combined with VFR. No v2 file was produced by that attempt. Replaced it
with encoder-only x264 fps=30/1 and explicit microsecond encoder time base,
retaining VFR timestamps. The v2 encode completed without the macroblock-rate
warning; JPEG range warning remains. Original pilot is preserved. Verify v2
PTS and decoded frames before accepting it; no synthetic30fps motion is claimed.

16:57 UTC: v2 pilot retains all89frames and maxPTS error0.825ms. Started a new
20-second normal-Space-input take under av-pilot-02 (session48310). It exited
without the AV_PILOT completion marker and with4ObjectDB/2resource warnings;
do not count exit0 as success. Partial artifacts are preserved. Determine the
termination cause and completeness before retrying; no successful take claimed.

17:28 UTC: Added close-request logging without disabling normal window close.
Retry av-pilot-03/session89661 printed CAPTURE_WINDOW_CLOSE_REQUESTED before
exiting early with the same cleanup warnings. This confirms a window-close
request terminated this take, not a completed recording. Source search found
no runtime quit calls. Do not suppress close requests or repeatedly reopen the
window; request a clear recording window from the user. Partial takes preserved.

2026-09-15 (ET) Claude Code, Bear's request: Liam walkthrough film. The earlier
window-close terminations were manual closes of the capture window (Bear
confirmed) plus, once, the tool sandbox; a third failure mode was macOS pausing
rendering of a fully occluded window, which stalls the real-time loop. The
harness now runs unsandboxed with a small always-on-top preview. New driver in
youtube/claude-liam-walker-audio-rhythm-game-walkthrough/_capture-project/:
30 fps grid with threaded JPEG (29.7 fps at native 4K), GUI input via
push_input in local coords, scene tracked by instance id. Three takes recorded
(full chart 103.8 s: 150/14/7 and Song Complete; pause/restart 32.1 s;
chart-select 19.4 s). Evidence gate PASS; Gate V clean with regional contrast
declared; final export in progress. Music silence during pause and beat-locked
metronome clicks were measured from the engine mix. Runtime game sources are
unchanged; the film does not claim heard synchronization or human play.
