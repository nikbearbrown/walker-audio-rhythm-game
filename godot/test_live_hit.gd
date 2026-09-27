extends SceneTree

# Normal Space input against the live scene clock; not a listening test.
func _initialize() -> void:
	run_probe.call_deferred()

func run_probe() -> void:
	var scene = load("res://scenes/main/main.tscn").instantiate()
	root.add_child(scene)
	var manager = scene.get_node("Notes")
	var deadline := Time.get_ticks_msec() + 30000
	var sent := false
	while Time.get_ticks_msec() < deadline:
		await process_frame
		if not manager._notes.is_empty() and abs(manager._get_note_delta(manager._notes[0])) < 0.015:
			var event := InputEventKey.new()
			event.physical_keycode = KEY_SPACE
			event.pressed = true
			Input.parse_input_event(event)
			sent = true
			await process_frame
			await process_frame
			event = InputEventKey.new()
			event.physical_keycode = KEY_SPACE
			event.pressed = false
			Input.parse_input_event(event)
			break
	var hit_ok: bool = sent and manager._play_stats.perfect_count == 1
	print("LIVE_SPACE_PERFECT ", hit_ok, " LABEL ", scene.get_node("Control/StatsVBox/PerfectLabel").text)
	scene.get_node("Conductor").stop()
	await create_timer(0.2).timeout
	await process_frame
	scene.queue_free()
	await process_frame
	await process_frame
	quit(0 if hit_ok else 1)
