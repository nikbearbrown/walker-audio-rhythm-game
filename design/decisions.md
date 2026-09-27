# walker-audio-rhythm-game — Open questions log

Zelda (agent, silent) · recovered · revision 1 · gate — unsigned at time of writing. Every `[MISSING]` in `GDD.md` is an entry here. Format: THE QUESTION / THE STAKES / DECISION DEADLINE / OPTIONS / OWNER / STATUS. Status is Open, In Discussion, or Decided. Decided items move into their section before the next session. Owner is proposed; nobody has accepted ownership.

| # | Question | Stakes | Deadline | Options | Owner | Status |
|---|---|---|---|---|---|---|
| Q-01 | Keep this a teaching demo, or grow it into a game (more charts, grades, persistence)? | Decides whether §7–10 and scoring ever get designed; the brief only covers the first adaptation. | before any feature work | (a) demo only (b) grow | Nik Bear Brown | Open |
| Q-02 | Who is the player/learner? | Latency tolerance, chart difficulty and film pacing depend on it. | before H-01 | (a) Godot learners (b) rhythm players (c) course students | Nik Bear Brown | Open |
| Q-03 | Player experience goals? | Without them H-01..H-03 have no pass line. | before H-01 | PX-01..04 candidates | Nik Bear Brown | Open |
| Q-04 | Pillars and feature priorities? | No CORE %; the brief's constraints are not pillars. | next design session | adopt P-01..P-03 or write new | Nik Bear Brown | Open |
| Q-05 | Is a score/grade wanted beyond counts and average error? Should misses count in the mean? | Mean error currently mixes early misses with hits; auto-misses excluded. | if Q-01 = grow | (a) keep (b) hits-only mean (c) add grade | Nik Bear Brown | Open |
| Q-06 | Should a late press (150–300 ms) register as a Miss? | Today the note auto-misses first; late presses do nothing, early ones consume a note. | before H-01 | (a) keep asymmetry (b) delay auto-miss to 300 ms | Nik Bear Brown | Open |
| Q-07 | Is `beat + output_latency_seconds` in the metronome a bug? | Clicks drift from notes if latency is large; a film may show the metronome as proof of sync. | before any metronome footage | (a) convert latency to beats (b) keep upstream, caption | Nik Bear Brown | Open |
| Q-08 | Is the song cleared for distribution? | SOURCES.md: authorship known, no separate license grant; blocks films and pushes. | before any film or push | (a) confirm upstream license covers it (b) replace track | Nik Bear Brown | Open |
| Q-09 | How is hardware latency calibrated, and is 20 ms the right default? | Wrong default makes every first run feel late or early. | before H-02 | (a) manual only (b) add calibration step | Nik Bear Brown | Open |
| Q-10 | Is note continuity after a long pause acceptable while the filter re-converges? | Possible visible jump on resume. | before pause footage | (a) accept (b) reset filter on resume | Nik Bear Brown | Open |
| Q-11 | Any progression or persistence (best scores, saved settings)? | Settings reset every launch today. | if Q-01 = grow | (a) none (b) save settings (c) + best scores | Nik Bear Brown | Open |
| Q-12 | Target platforms (desktop only, Web)? | Web has a known mix-timing bug guarded in code; timing claims differ per platform. | before any export | (a) macOS only (b) + Web | Nik Bear Brown | Open |
| Q-13 | Confirm world, narrative and characters are out of scope. | Prevents invented lore. | next design session | (a) confirm N/A (b) define | Nik Bear Brown | Open |
| Q-14 | More charts or songs? | Sync Test reuses the one song and tempo; new songs need BPM/offset per chart. | if Q-01 = grow | (a) no (b) add per-chart song fields | Nik Bear Brown | Open |
