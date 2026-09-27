extends SceneTree

# Constructed component test, not real-time gameplay or audio-sync evidence.
func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var conductor := Conductor.new()
	conductor.bpm = 120
	var note = load("res://objects/note/note.tscn").instantiate()
	note.conductor = conductor
	note.beat = 4
	root.add_child(note)
	note.set_process(false)
	note.update_beat(3)
	var before_ok: bool = is_equal_approx(note.position.y, -200.0)
	note.update_beat(4)
	var at_ok: bool = is_equal_approx(note.position.y, 0.0)
	note.update_beat(5)
	var after_ok: bool = is_equal_approx(note.position.y, 100.0)
	print("NOTE_MOTION before=", before_ok, " at=", at_ok, " after=", after_ok)
	note.queue_free()
	await process_frame
	conductor.free()
	quit(0 if before_ok and at_ok and after_ok else 1)
