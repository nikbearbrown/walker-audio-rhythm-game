extends Node

# Constructed unit fixture: controlled timing, not gameplay capture.
class FixtureManager extends NoteManager:
	var test_delta: float = 0.0
	func _ready() -> void:
		_play_stats = PlayStats.new()
	func _get_note_delta(_note: Note) -> float:
		return test_delta
	func _process(_delta: float) -> void:
		pass

func _ready() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var passed := 0
	var cases = [[0.0, "perfect_count"], [0.05, "perfect_count"],
		[-0.05, "perfect_count"], [0.10, "good_count"],
		[-0.10, "good_count"], [-0.20, "miss_count"]]
	for sample in cases:
		var manager := FixtureManager.new()
		get_tree().root.add_child(manager)
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
		await get_tree().process_frame
	var empty_manager := FixtureManager.new()
	get_tree().root.add_child(empty_manager)
	empty_manager._handle_keypress()
	var empty_ok: bool = empty_manager._notes.is_empty() and empty_manager._play_stats.miss_count == 0
	print("EMPTY_INPUT ", empty_ok)
	empty_manager.queue_free()
	await get_tree().process_frame
	get_tree().quit(0 if passed == cases.size() and empty_ok else 1)
