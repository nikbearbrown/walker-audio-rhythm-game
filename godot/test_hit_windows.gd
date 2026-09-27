extends SceneTree

# Constructed unit fixture: controlled timing, not gameplay capture.
class FixtureManager extends NoteManager:
	var test_delta: float = 0.0
	func _ready() -> void:
		_play_stats = PlayStats.new()
	func _get_note_delta(_note: Note) -> float:
		return test_delta
	func _process(_delta: float) -> void:
		pass

func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var passed := 0
	var cases = [[0.0, "perfect_count"], [0.05, "perfect_count"],
		[-0.05, "perfect_count"], [0.10, "good_count"],
		[-0.10, "good_count"], [-0.20, "miss_count"]]
	for sample in cases:
		var manager := FixtureManager.new()
		root.add_child(manager)
		manager.test_delta = sample[0]
		var note = load("res://objects/note/note.tscn").instantiate()
		note.set_process(false)
		manager.add_child(note)
		manager._notes.append(note)
		manager._handle_keypress()
		var ok: bool = manager._play_stats.get(sample[1]) == 1 and manager._notes.is_empty()
		print("HIT_WINDOW ", sample, " ", ok)
		if ok:
			passed += 1
		manager.queue_free()
		await process_frame
	quit(0 if passed == cases.size() else 1)
